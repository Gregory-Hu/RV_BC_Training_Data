
  input wire [`RV_BC_UID] rtc_uid_q,
  input wire commit_advance_q,


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
// issue pipeline vld
  assign iss_not_splitted_spec_v_i2 = iss_v_i2_q & ~splitted_unaln_i2;
  assign iss_v_a1 = iss_ld_a1_q | iss_st_a1_q;

// issue uop age 
  assign oldest_uop_i2 = iss_v_i2_q & (uid_i2_q[`RV_BC_UID] == rtc_uid_q[`RV_BC_UID]); 

// --------------------------------------
// A1 Stage 

  // pipeline reg

  always_ff @(posedge clk or negedge reset_n)
  begin
    if (reset_n == 1'b0)
      oldest_uop_a1_q <= {1{1'b0}};
    else if (issue_v_poss_ls0_i2 == 1'b1)
      oldest_uop_a1_q <= `RV_BC_DFF_DELAY oldest_uop_i2;
  end

  // load store decode
  // rvv decode 
  assign unit_fault_only_first_ld_a1   = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_UNIT_FOF;
  assign gather_fault_only_first_ld_a1 = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_GATHER_FOF;
  assign ordered_gather_ld_a1          = ls_uop_ctl_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_RVV_ORDERED_GATHER;


// --------------------------------------
// unalign split
  assign need_split_a1 =   ~splitted_unaln_a1_q
                         & ( 
                             iss_ld_v_a1 & (cross_cl_a1 | word_conflict_split_a1) | 
                             iss_st_v_a1 & cross_page_a1
                            );
  
  assign prevent_split_a1 = oldest_uop_i2 & licklock_rslv_cnt_sat | 
                            tmo_pf_inj_a1;

  assign splitted_unaln_i2 = need_split_a1 & ~prevent_split_a1;

  assign reiss_i2 = iss_v_i2_q & splitted_unaln_i2;  

  assign reiss_a1 = need_split_a1 & prevent_split_a1;

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
