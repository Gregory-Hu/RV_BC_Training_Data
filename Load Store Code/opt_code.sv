


  // high miss activity micro-arch power throttle
  always_ff @(posedge clk or posedge reset_i)
  begin
    if (reset_i == 1'b1)
      disable_iq_ld_arb_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0)
      disable_iq_ld_arb_q <= `RV_BC_DFF_DELAY disable_iq_ld_arb_nxt;
    else
      disable_iq_ld_arb_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else
      disable_iq_ld_arb_q <= `RV_BC_DFF_DELAY disable_iq_ld_arb_nxt;
`endif
  end



  assign disable_iq_ld_pipe2_arb = 1'b0;



  // store forward miss fetch
  assign wtb_full_din = wtb_stall_t2 & ~stream_no_allocate_mode_q & ~prevent_st_issue_pf & ~disable_hw_pref_st_issue;        

  always_ff @(posedge clk)
  begin
    wtb_full_q <= wtb_full_din;
  end




  always_ff @(posedge clk or posedge reset_i)
  begin: u_blk_non_oldest_ld_q
    if (reset_i == 1'b1)
      blk_non_oldest_ld_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0)
      blk_non_oldest_ld_q <= `RV_BC_DFF_DELAY blk_non_oldest_ld;
    else
      blk_non_oldest_ld_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else
      blk_non_oldest_ld_q <= `RV_BC_DFF_DELAY blk_non_oldest_ld;
`endif
  end



  
  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_st_pf_on_rst_full_a1_q
    if (reset_i == 1'b1)
      ls1_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls1_st_pf_on_rst_full_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls1_st_pf_on_rst_full_i2;
`endif
  end
