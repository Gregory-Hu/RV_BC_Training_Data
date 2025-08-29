module rv_bc_ls_agu #(
) (

  input wire iss_v_i1_spec,
  input wire iss_v_i1,
  input wire iss_sid_v_i1,

  input wire [`RV_BC_UID] ls_uid_i1,
  input wire [3:0] ls_sid_i1,

  input wire [`RV_BC_UID] rtc_uid_q,
  input wire commit_advance_q,
  
  // src operand src0 src1 srcm(vector mask)
  input wire ls_src0_v_i2,       
  input wire [63:0] ls_src0_data_i2,  
  input wire ls_src1_v_i2,       
  input wire [63:0] ls_src1_data_i2,  

  input wire ls_srcm_v_i2,       
  input wire [`RV_BC_LS_RVV_MASK_W-1:0] ls_srcm_data_i2,  

  input wire [6:0] ls_vl_i2,

  // OoO flush 
  input wire flush,
  input wire [`RV_BC_UID] flush_uid,
);

// -------------------------------------
// AGU Implement the following features
//     OoO Operation Age 
//     pipeline valid management
//     micro-operation (uop) decode
//     src operand processing
//     prefetch
//     RAW Prediction


// -------------------------------------
// module clock gating

  assign agu_clk_gating_din = iss_v_i1 | iss_v_i2_q | csr_disable_ls_clk_gating;


  always_ff @(posedge clk)
    agu_clk_gating_q <= agu_clk_gating_din

   rv_bc_clkgate u_clk_agu (
        .clk          (clk),
        .enable_i     (agu_clk_gating_q),
        .clk_gated    (clk_agu)
   );

// --------------------------------------
// pipeline flush 
  rv_bc_flush_match u_flush_match_i2 (
      .flush_match (flush_i2),
      .flush       (flush),
      .flush_uid   (flush_uid[`RV_BC_UID]), 
      .uop_uid     (uid_i2_q[`RV_BC_UID]) 
  );

// --------------------------------------
// issue pipeline vld

  // pipe reg en 
  assign any_iss_v = iss_v_i2_q | 
                     iss_ld_v_a1_q | iss_st_v_a1_q | 
                     ld_v_a2_q | st_v_a2_q;

  // I2 Stage
  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      iss_v_i2_q <= {1{1'b0}};
    else
      iss_v_i2_q <= iss_v_i1;
  end


  // pipe valid spec valid bits 
  assign iss_v_i2_spec = iss_v_i2_q & ~splitted_unaln_i2;

  assign iss_ld_v_i2_spec = iss_v_i2_q & ld_i2 & ~tmo_pf_i2;
  assign iss_st_v_i2_spec = iss_v_i2_q & st_i2 & ~tmo_pf_i2;

  assign iss_v_i2 =   iss_v_i2_q 
                    & ~iss_cancel_i2
                    & (~uop_flush_i2 | tmo_pf_i2)
                    & ~splitted_unaln_i2;

  assign iss_ld_v_i2 = iss_v_i2 & ld_i2;
  assign iss_st_v_i2 = iss_v_i2 & st_i2;
  assign iss_gs_v_i2 = iss_v_i2 & (gather_i2 | scatter_i2);

  // A1 Stage
  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      iss_ld_v_a1_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      iss_ld_v_a1_q <= iss_ld_i2;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      iss_st_v_a1_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      iss_st_v_a1_q <= iss_st_v_i2;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      iss_gs_v_a1_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      iss_gs_v_a1_q <= iss_gs_v_i2;
  end

  assign iss_v_a1 = iss_ld_v_a1_q | iss_st_v_a1_q;

  assign ld_v_a1 = splitted_unaln_a1_q ? ld_v_a2_q : iss_ld_v_a1_q;
  assign st_v_a1 = splitted_unaln_a1_q ? st_v_a2_q : iss_st_v_a1_q;
  assign gs_v_a1 = splitted_unaln_a1_q ? gs_v_a2_q : iss_gs_v_a1_q;

  // A2 Stage
  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      st_v_a2_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      st_v_a2_q <= st_v_a1;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      ld_v_a2_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      ld_v_a2_q <= ld_v_a1;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      gs_v_a2_q <= {1{1'b0}};
    else if (any_iss_v == 1'b1)
      gs_v_a2_q <= gs_v_a1; 
  end




  assign tmo_pf_vld_en = pf_req_iss_v | tmo_req_iss_v |
                         pf_v_i2_q | tmo_v_i2_q | 
                         pf_v_a1_q | tmo_v_a1_q | 
                         pf_v_a2_q | tmo_v_a2_q ;
                         

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      tmo_v_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (tmo_pf_vld_en == 1'b1)
      tmo_v_i2_q <= `RV_BC_DFF_DELAY tmo_req_iss_v;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      tmo_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (tmo_pf_vld_en == 1'b1)
      tmo_v_a1_q <= `RV_BC_DFF_DELAY tmo_v_i2_q;
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls0_a2_q
    if (reset_i == 1'b0)
      tmo_v_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (tmo_pf_vld_en == 1'b1)
      tmo_v_a2_q <= `RV_BC_DFF_DELAY tmo_v_a1_q;
  end


  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      pf_v_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (pf_pf_vld_en == 1'b1)
      pf_v_i2_q <= `RV_BC_DFF_DELAY pf_req_iss_v;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      pf_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (pf_pf_vld_en == 1'b1)
      pf_v_a1_q <= `RV_BC_DFF_DELAY pf_v_i2_q;
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_inject_val_ls0_a2_q
    if (reset_i == 1'b0)
      pf_v_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
    else if (pf_pf_vld_en == 1'b1)
      pf_v_a2_q <= `RV_BC_DFF_DELAY pf_v_a1_q;
  end

  assign tmo_pf_i2 = tmo_v_i2_q | pf_v_i2_q;

// --------------------------------------
// issue uop age identifiers

  always_ff @(posedge clk)
  begin
    if (iss_v_i1_spec == 1'b1)
      uid_i2_q[`RV_BC_UID] <= ls_uid_i1[`RV_BC_UID];
  end

  always_ff @(posedge clk)
  begin
    if (iss_sid_v_i1 == 1'b1)
      sid_i2_q[3:0] <= ls_sid_i1[3:0];
  end



  assign oldest_uop_i2 = iss_v_i2_q & (uid_i2_q[`RV_BC_UID] == rtc_uid_q[`RV_BC_UID]); 

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      oldest_uop_a1_q <= {1{1'b0}};
    else if (issue_v_poss_ls0_i2 == 1'b1)
      oldest_uop_a1_q <= `RV_BC_DFF_DELAY oldest_uop_i2;
  end


// --------------------------------------
// issue decode 
  // i2 stage 
  assign ld_i2 = ~ls_uop_ctl_i2_q[`RV_BC_LS_CTL_STORE] & ~tmo_pf_i2;
  assign st_i2 =  ls_uop_ctl_i2_q[`RV_BC_LS_CTL_STORE] & ~tmo_pf_i2;
  assign vec_i2 = (ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_LD | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_PRED_LD | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER_FOF | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_FOF | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_ORDERED_GATHER | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_ST |
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_PRED_ST |  
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SCATTER | 
                   ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SEG_SCATTER);

  assign gather_i2 = (ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER_FOF | 
                      ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER | 
                      ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_SEG_GATHER ) & ~tmo_pf_i2;
  assign scatter_i2 = (ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_ST | 
                       ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SCATTER | 
                       ls_uop_ctl_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SEG_SCATTER );
  // a1 stage 
  assign unit_fault_only_first_ld_a1   = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_FOF;
  assign gather_fault_only_first_ld_a1 = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER_FOF;
  assign ordered_gather_ld_a1          = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_ORDERED_GATHER;

  assign need_pf_a1 = st_v_a1 & (ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_ST |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SC |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_ST | 
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SCATTER | 
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_SEG_SCATTER) |
                      ld_v_a1 & (ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LD |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LR |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_FOF |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_LD |
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER_FOF | // actually segmented 
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER | // actually segmented 
                                 ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_SEG_GATHER  // actually segmented 
                                 );
                                

  always_ff @(posedge clk_agu)
  begin
    if (iss_v_i2_spec == 1'b1)
      gather_a1_q <= `RV_BC_DFF_DELAY gather_i2;
  end


// --------------------------------------
// unalign split
  assign need_split_a1 =   ~splitted_unaln_a1_q
                         & ( 
                             iss_ld_v_a1 & (cross_cl_a1 | word_conflict_split_a1) | 
                             iss_st_v_a1 & cross_page_a1
                            );
  
  assign prevent_split_a1 = oldest_uop_i2 & licklock_rslv_cnt_sat | 
                            tmo_pf_inj_a1_q;

  assign splitted_unaln_i2 = need_split_a1 & ~prevent_split_a1;

  assign reiss_i2 = iss_v_i2_q & splitted_unaln_i2;  

  assign reiss_a1 = need_split_a1 & prevent_split_a1;
  assign reiss_d1 = reiss_a1;


// --------------------------------------
// unalign crack licklock resolve

  assign oldest_uop_reiss = reiss_i2 & oldest_uop_i2 | 
                            oldest_uop_a1_q &  reject_unalign_ls0_a1;

  assign oldest_uop_reiss_cnt_clr =   iss_v_a1 
                                    & oldest_uop_a1_q 
                                    & ~unaln_reiss_a1 & ~splitted_unaln_a1_q;

  assign licklock_rslv_cnt_clr = oldest_uop_reiss_cnt_clr | commit_advance_q;

  assign licklock_rslv_cnt_din[1:0] = oldest_uop_reiss & ~licklock_rslv_cnt_sat ? licklock_rslv_cnt_q[1:0] + 2'b01 :
                                                          licklock_rslv_cnt_clr ? 2'b00 
                                                                                : licklock_rslv_cnt_q[1:0];

  assign licklock_rslv_cnt_sat = (licklock_rslv_cnt_q[1:0] == 2'b11);

  assign licklock_rslv_cnt_en = oldest_uop_i2 | oldest_uop_a1_q;

  always_ff @(posedge clk)
  begin if(licklock_rslv_cnt_en)
    licklock_rslv_cnt_q[1:0] <= licklock_rslv_cnt_din[1:0];
  end


// --------------------------------------
// source operand processing 

  // mask source 
  assign srcm_v_i2 = splitted_unaln_i2 ? srcm_v_a1_q 
                                       : ls_srcm_v_i2 & iss_v_i2_spec;

  assign srcm_clk_en = srcm_v_i2 | srcm_v_a1_q | srcm_v_a2_q;

  assign srcm_wr_i2 = ls_srcm_v_i2 & iss_v_i2_spec & ~splitted_unaln_i2;
  assign vl_wr_i2   = iss_v_i2_spec & ~splitted_unaln_i2 & vec_i2;

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      srcm_v_a1_q <= {1{1'b0}};
    else if (srcm_clk_en == 1'b1)
      srcm_v_a1_q <= srcm_v_i2;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      srcm_v_a2_q <= {1{1'b0}};
    else if (srcm_clk_en == 1'b1)
      srcm_v_a2_q <= srcm_v_a1_q;
  end

  always_ff @(posedge clk_agu)
  begin
    if (srcm_wr_i2 == 1'b1)
      srcm_data_a1_q[15:0] <= ls_srcm_data_i2[15:0];
  end

  always_ff @(posedge clk_agu)
  begin
    if (vl_wr_i2 == 1'b1)
      ls_vl_a1_q[6:0] <= ls_vl_i2[6:0];
  end


  // Unit Mask Expand
  assign srcm_data_a1[15:0] =   srcm_data_a1_q[15:0] 
                              & vstart_mask_data_a1[15:0]
                              & vl_mask_data_a1[15:0];

  always_comb 
  begin
    case(ew_a1_q[1:0])
      2'b00: unit_mask_a1[15:0] = srcm_data_a1[15:0];  
      2'b01: unit_mask_a1[15:0] = {{2{srcm_data_a1[7]}}, 
                                   {2{srcm_data_a1[6]}}, 
                                   {2{srcm_data_a1[5]}}, 
                                   {2{srcm_data_a1[4]}}, 
                                   {2{srcm_data_a1[3]}}, 
                                   {2{srcm_data_a1[2]}}, 
                                   {2{srcm_data_a1[1]}}, 
                                   {2{srcm_data_a1[0]}}};  
      2'b10: unit_mask_a1[15:0] = {{4{srcm_data_a1[3]}}, 
                                   {4{srcm_data_a1[2]}}, 
                                   {4{srcm_data_a1[1]}}, 
                                   {4{srcm_data_a1[0]}}};    
      2'b11: unit_mask_a1[15:0] = {{8{srcm_data_a1[1]}}, 
                                   {8{srcm_data_a1[0]}}};  
      default: unit_mask_a1[15:0] = {16{1'bx}};
    endcase
  end




  // predicate load support tail ceil(vl)
  // predicate length can be scaled to 8*16, 128 bits, 16 byte 
  // vector length total is 16*8 128 bits -> vl of 7 bits
































endmodule 