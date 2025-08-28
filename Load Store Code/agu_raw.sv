//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from Arm Limited or its affiliates.
//
//            (C) COPYRIGHT 2015-2022 Arm Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from Arm Limited or its affiliates.
//
//            Release Information : RV_BC-MP128-r0p3-00rel0
//
//-----------------------------------------------------------------------------
// SystemVerilog-2012 (IEEE Std 1800-2012)
//-----------------------------------------------------------------------------


`include "rv_bc_header.sv"
`include "rv_bc_ls_defines.sv"
`include "rv_bc_ls_params.sv"
`include "rv_bc_lsl2_defines.sv"


module rv_bc_ls_agu  `RV_BC_LS_CACHE_SIZE_PARAM_DECL
(
  input wire clk,
  input wire reset_i,
  input wire cb_dftcgen,

  input wire                                   coh_icache_dis,                         
  input wire                                   chka_disable_ls_rcg,           
  input wire                                   ls_16_of_64_tick_tock,         
  input wire                                   wayt_ct_tofu_vld_q,            


  input wire                                  disable_hw_pref_st_issue,      
  input wire                                  disable_iq_ld_arb_nxt,
   input wire                                 block_ls_1,
   input wire                                 block_ls_2,

  input wire                                  rar_entry_supermerged_q,

  input wire                                  pf_debug_state,
  input wire  [`RV_BC_UID]                     ct_precommit_uid,              
  output reg [`RV_BC_UID]                     precommit_uid_q,               
  output wire [`RV_BC_UID]                     rar_precommit_uid,               
`ifdef VALIDATION
  output reg [63:0]                          precommit_instr_id_q,          
`endif
  output reg                                  precommit_uid_advance_q,       


 input wire                                    rst_hit_count_sat,


  input wire                                   spe_tlb_lookup_req,            
  input wire [`RV_BC_LS_VA_MAX:12]              spe_tlb_lookup_req_va,         

  output wire                                  spe_injection_req_made,
  output wire                                  spe_inject_val_a2,

  input wire                                   tbe_tlb_lookup_req,         
  input wire [`RV_BC_LS_VA_MAX:12]              tbe_tlb_lookup_req_va,     

  output wire                                  tbe_injection_req_made,
  output wire                                  tbe_inject_val_a2,


  input wire                                   mx_ls_sve_vlen,
  input wire                                   ls_enable_serialize_gather,
  
  input wire                                   pf_tlb_lookup_req_q,
  input wire [`RV_BC_LS_VA_MAX:12]              pf_tlb_lookup_va_q,
  input wire [`RV_BC_LS_PF_GT_TLB_ID_R]         pf_tlb_lookup_id_q,
  output wire                                  pf_tlb_lookup_req_accepted,
  output wire                                  pf_accepted_tlb_lookup_drop,
  output wire [`RV_BC_LS_PF_GT_TLB_ID_R]        pf_accepted_tlb_lookup_drop_id,

  input wire                                   snp_sync_in_progress,             

  input wire                                   ls_drain,
  input wire                                   ls_spr_drain,
  input wire                                   clr_all_gen_entries_q,


  input wire                                   any_snp_tmo_req,  
  input wire  [`RV_BC_LS_VA_MAX:12]             snp_tmo_req_addr,
  input wire                                   snp_queue_full,                      
  output wire                                  tmo_req_done_i2,
  output wire                                  tmo_injection_req_made,


  output wire                                  ls_is_addr_inject_v,              
  output wire [`RV_BC_LS_VA_MAX:12]           ls_is_addr_inject,                                                                                          
  output wire                                  ls0_snp_inject_bubble_req,        
  output wire                                  ls1_snp_inject_bubble_req,        
  output wire                                  ls2_snp_inject_bubble_req,        

  output wire                                  pref_addr_inject_outstanding,  
  output reg [`RV_BC_LS_PF_GT_TLB_ID_R]        pf_tlb_lookup_injected_id_a2_q,    
  input wire                                   inject_iq_bubble_for_late_resolve,   
  input wire                                   invdbg_ok,                     
  input wire                                   stream_no_allocate_mode_q,     

  input wire                                   blk_non_oldest_ld,             




  input wire                                   is_ls_oldest_ld_v_ls0,
  input wire [`RV_BC_UID]                       is_ls_oldest_ld_uid_ls0,
  input wire                                   is_ls_oldest_ld_rid_ls0,

  input wire                                   is_ls_dstx_v_ls0_new_i2,
  input wire                                   is_ls_dstx_v_ls0_i2_q,
  input wire                                   is_ls_dsty_v_ls0_i2_q,

  output reg  [63:0]                          agu_addend_a_ls0_a1_q,
  output reg  [63:0]                          agu_addend_b_ls0_a1_q,

  input wire   [2:0]                           is_ls_dst_size_ls0_i2_q,
  
  input wire                                    ls0_ccpass_a2_q,
  input wire                                    ls0_iq_ld_dev_a2,
  
  output wire                                   ls0_type_ldg_i2,
  
  output reg                                   ls0_frc_unchecked_a1_q,

  output wire  [4:0]             ls0_srca_hash_a1,            
  output reg  [4:0]             ls0_srca_hash_a2_q,          

  output wire                                   ls0_sp_base_a1,              

  output reg                                   ls0_st_pf_on_rst_full_a1_q,  

  output wire                                  carry_in_ls0_a1_q,

  output reg                                  ls0_precommit_uop_a1_q, 

  input wire [63:0]                            ls0_cin_a1,
  input wire [63:0]                            va_ls0_a1,                   
  output wire                                  ls0_fast_cout11_a1,          

  input wire [11:0]                            va_ls0_a2_q,                 
  output wire [2:0]                            ls0_element_size_a1,         
  output reg                                  ls0_ld_unpred_sve_uop_a1_q,  
  output reg [4:0]                            bytes_to_page_split_ls0_a2_q,  
  output reg                                  ls0_valid_multi_reg_ld_st_op_a2_q,   
  input wire                                   valid_xlat_uop_ls0_a1,            
  output wire  [4:0]                           first_active_byte_ls0_a2,
  input wire   [2:0]                           ls0_element_size_a2,
  output reg  [31:0]                          cont_ld_ffr_lane_dec_ls0_a1,

  input wire                                   is_ls_issue_v_ls0_i1,        
  input wire                                   is_ls_issue_type_ls0_i1,     


  input wire  [`RV_BC_UID]                      is_ls_uid_ls0_i1,            
  input wire                                   is_ls_rid_ls0_i1, 
`ifdef VALIDATION
  input wire  [63:0]                           is_ls_instr_id_ls0_i1,       
`endif
  input wire  [`RV_BC_STID]                     is_ls_stid_ls0_i1,           
  input wire  [1:0]                            is_ls_srca_v_ls0_i2,         
  input wire  [63:0]                           is_ls_srca_data_ls0_i2,      

  input wire  [1:0]                            is_ls_srcb_v_ls0_i2,         
  input wire  [63:0]                           is_ls_srcb_data_ls0_i2,      

  input wire                                   is_ls_srcp_v_ls0_i2,         
  input wire  [3:0]                            is_ls_srcp_data_ls0_i2,      

  input wire  [15:1]                           is_ls_pc_ls0_i2,             

  input wire                                   is_ls_force_unchecked_ls0_i2, 

  input wire                                   ls0_ldg_ld_a1,
  input wire                                   ls0_ldgm_ld_a1,

  input wire                                   is_ls_srcpg_v_ls0_i2,       
  input wire [`RV_BC_LS_SVE_PRED_RANGE]         is_ls_srcpg_data_ls0_i2,    

  input wire [2:0]                             is_ls_dstx_vlreg_ls0_i2_q,    
  input wire [1:0]                             is_ls_dsty_vlreg_ls0_i2_q,    

  input wire                                   ls0_ld_ssbb_blk_i2,
  input wire                                   ls0_ld_ssbb_blk_a1_q,

  output reg [31:0]                           ls0_srcpg_data_a1,           
  output reg [31:0]                           ls0_srcpg_data_a2_q,         
  output reg                                  ls0_srcpg_v_a1_q,            
  output reg                                  ls0_srcpg_v_a2_q,            
  output wire                                  ls0_scatter_gather_v_i2,    
  
  output wire [31:0]                           ls0_parsed_pred_a1,
  output wire                                  ls0_lo_pred_non_zero_a1,     
  output wire                                  ls0_hi_pred_non_zero_a1,     
  output wire                                  ls0_pred_inv_force_ccfail_a1,  
  output wire                                  ls0_pred_all_inv_a1,  
  
  output wire                                  ff_or_nf_ld_ls0_a2,                               
  output wire                                  ff_ld_ls0_a2,                                     
  output reg [4:0]                            ffr_lane_ls0_a2_q,                                
  output wire                                  nf_ld_ls0_a2,                                     
  output wire                                  ff_cont_ld_ls0_a2,                                
  output wire                                  ff_gather_ld_ls0_a2,                              
  output wire                                  ffr_lane_eq_first_active_lane_ls0_a2,             
  output wire                                  first_vld_lane_found_ls0_a2,                      
  output wire                                  mid_first_lane_page_split_ls0_a2,                 
  output reg [1:0]                            ls0_ln_size_a2_q,                                 
  output wire                                  more_than_one_active_lane_ls0_a2,                 
  output wire [4:0]                            cont_ld_second_ffr_lane_ls0_a2,                   
  output wire                                  vld_split_lane_found_ls0_a1,                      
  input wire                                   ls0_sp_align_flt_a1,                              
  input wire                                   ls0_sp_align_flt_a2_q,                            
  output reg                                  chk_bit_ffr_upd_ls0_a2_q,                         
  output reg [4:0]                            chk_bit_ffr_lane_ls0_a2_q,                        
  
  output wire                                  ls0_empty_predicate,                              
  output wire                                  ls0_partial_predicate,                            
  

  output wire                                  issue_ld_val_possible_ls0_i2, 
  output wire                                  issue_pld_val_possible_ls0_i2, 
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls0_pc_index_i2,


  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls0_pc_index_a1_q,             
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls0_lpt_cam_pc_index_a1_q,     
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls0_lpt_cam_pc_index_dup_a1_q, 

  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls0_pc_index_a2_q,            

  input wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]     ls0_pc_index_d4,
  input wire                                   ls0_ld_vld_raw_haz_nuke_me_d4,  
  input wire                                   ls0_ld_vld_lpt_hit_d4,          
  input wire                                   ls0_ld_vld_sb_fwd_lpt_alloc_d4,              
  input wire                                   ls0_ld_uop_vld_d4,

  output reg                                  ls0_pf_trainable_type_a2_q,   
  input wire  [`RV_BC_LS_CTL]                   ls_uop_ctl_ls0_i2_q,          
  input wire                                   is_ls_issue_cancel_ls0_i1,   

  input wire                                   is_ls_dep_d3_resx_ls0_i1,    
  input wire                                   is_ls_dep_d3_resy_ls0_i1,

  input wire                                   is_ls_dep_d3_resz_ls0_i1,

  input wire                                   is_ls_issue_cancel_ls0_i2,         
  input wire                                   ls0_ld_reject_gather_i2,

  output wire [28:0]                           va_dup_ls0_a1,               
  output wire [3:0]                            va_adjust_ls0_a1,            

  output wire [5:0]                            end_byte_adjust_ls0_a1,      
  output reg                                  ls0_ld_cross_16_32_byte_a2_q,  
  output reg                                  ls0_ld_cross_32_byte_a2_q,   

  output reg                                  issue_v_ls0_i2_q,            
  output wire                                  issue_st_val_ls0_i2,         
  output wire                                  tmo_inject_val_ls0_i2,       
  output reg                                  address_inject_val_ls0_i2_q, 

  output reg                                  tmo_inject_val_ls0_a1_q,     
  output reg                                  tmo_inject_val_ls0_a2_q,     

  output wire                                  spe_inject_val_ls0_i2,       
  output reg                                  spe_inject_val_ls0_a1_q,     
  output reg                                  spe_inject_val_ls0_a2_q,     

  output wire                                  tbe_inject_val_ls0_i2,       
  output reg                                  tbe_inject_val_ls0_a1_q,     
  output reg                                  tbe_inject_val_ls0_a2_q,     


  output wire                                  pf_tlb_inject_v_ls0_i2,      
  output wire                                  pf_tlb_inject_v_ls0_a1,      
  output wire                                  pf_tlb_inject_v_ls0_a2,      
  output reg                                  address_inject_val_ls0_a1_q, 
  output reg                                  address_inject_val_ls0_a2_q, 

  output wire                                  issue_v_ls0_i2,              
  output wire                                  issue_v_early_ls0_i2,        
  output wire                                  issue_ld_val_ls0_i2,
  output wire                                  issue_ld_val_early_ls0_i2,
  output wire                                  tlb_cam_v_ld_st_ccpass_ls0_a1,              
  output wire                                  tlb_cam_v_ls0_a1,                           
  output wire                                  va_v_ls0_a1,                                
  output wire                                  unalign1_ls0_a1,             
  output reg [`RV_BC_UID]                      uid_ls0_i2_q,
  output reg                                  rid_ls0_i2_q,
`ifdef VALIDATION
  output reg  [63:0]                          instr_id_ls0_i2_q,           
`endif
  input wire                                   st_no_xlat_ls0_a1,           
  output reg [`RV_BC_STID]                     ls0_stid_i2_q,               

  output wire                                  ld_val_ls0_a1,
  output wire                                  st_val_ls0_a1,
  output reg                                  st_val_ls0_a2_q,
  output wire                                  unalign2_ls0_a1_q,              
  output wire                                  cache_line_split_ls0_a1,        
  output wire                                  st_cache_line_split_ls0_a1,  
  output wire                                  st_low_cache_line_split_ls0_a1,  
  output wire                                  st_mid_cache_line_split_ls0_a1,  
  output wire                                  st_hi_cache_line_split_ls0_a1,  
  output reg                                  srca_v_ls0_a1_q,             

  output reg                                  ld_val_ls0_arb_possible_a1_q,          

  output wire [5:0]                            end_byte_ls0_a1,             
  output wire [5:3]                            st_low_end_byte_ls0_a1,      
  output reg [`RV_BC_STID]                   stid_ls0_a1_q,               
  output wire [`RV_BC_LS_CTL]                 ls_uop_ctl_ls0_a1_q,        
  output wire                                  ls0_uop_cross_16_byte_a1,    
  output wire                                  ls_ctl_format_ls0_a1,        
  output wire                                  ccpass_ls0_a1,               
  output reg                                  ls0_ccpass_st_a2_q,          
  output wire                                  reject_unalign_ls0_a1,       

  output wire                                  iq0_gather_ld_i2,
  output reg                                  iq0_gather_ld_a1_q,
  output reg                                  iq0_gather_ld_a2_q,
  
  output wire                                  unalign2_ls0_i2,
  output reg                                  unalign2_ls0_a2_q,
  output reg [`RV_BC_STID]                   stid_ls0_a2_q,               

  output wire                                  ls0_ld_unalign1_a1,          
  output wire                                  ls0_ld_unalign1_qual_a1,     
  output wire                                  ls0_ld_unalign1_a2,

  output wire                                  ls0_ld_page_split1_a1,        
  output wire                                  ls0_ld_page_split1_a2,
  output wire                                  ls0_st_page_split1_a1,
  output wire                                  ls0_page_split1_val_a1,

  output wire                                  ls0_ld_unalign2_a1,          

  output wire                                  ls0_ld_page_split2_a1,        

  output wire                                  ls0_uop_flush_i2,

  output wire                                  ls_is_uop_reject_ls0_i2,     
  output wire                                  ls_is_uop_reject_ls0_d1, 
 
  output reg                                  ls0_page_split2_a1_q,

  output reg                                  ls0_page_split2_a2_q,

  output wire [15:0]                           wv_ls0_a1,                   
  output wire [7:0]                            bank_dec_ld_ls0_a1,          
                                                                         
   output wire [31:0]                          byte_access_map_ls0_a1,                                                                            



  input wire                                   is_ls_oldest_ld_v_ls1,
  input wire [`RV_BC_UID]                       is_ls_oldest_ld_uid_ls1,
  input wire                                   is_ls_oldest_ld_rid_ls1,

  input wire                                   is_ls_dstx_v_ls1_new_i2,
  input wire                                   is_ls_dstx_v_ls1_i2_q,
  input wire                                   is_ls_dsty_v_ls1_i2_q,

  output reg  [63:0]                          agu_addend_a_ls1_a1_q,
  output reg  [63:0]                          agu_addend_b_ls1_a1_q,

  input wire   [2:0]                           is_ls_dst_size_ls1_i2_q,
  
  input wire                                    ls1_ccpass_a2_q,
  input wire                                    ls1_iq_ld_dev_a2,
  
  output wire                                   ls1_type_ldg_i2,
  
  output reg                                   ls1_frc_unchecked_a1_q,

  output wire  [4:0]             ls1_srca_hash_a1,            
  output reg  [4:0]             ls1_srca_hash_a2_q,          

  output wire                                   ls1_sp_base_a1,              

  output reg                                   ls1_st_pf_on_rst_full_a1_q,  

  output wire                                  carry_in_ls1_a1_q,

  output reg                                  ls1_precommit_uop_a1_q, 

  input wire [63:0]                            ls1_cin_a1,
  input wire [63:0]                            va_ls1_a1,                   
  output wire                                  ls1_fast_cout11_a1,          

  input wire [11:0]                            va_ls1_a2_q,                 
  output wire [2:0]                            ls1_element_size_a1,         
  output reg                                  ls1_ld_unpred_sve_uop_a1_q,  
  output reg [4:0]                            bytes_to_page_split_ls1_a2_q,  
  output reg                                  ls1_valid_multi_reg_ld_st_op_a2_q,   
  input wire                                   valid_xlat_uop_ls1_a1,            
  output wire  [4:0]                           first_active_byte_ls1_a2,
  input wire   [2:0]                           ls1_element_size_a2,
  output reg  [31:0]                          cont_ld_ffr_lane_dec_ls1_a1,

  input wire                                   is_ls_issue_v_ls1_i1,        
  input wire                                   is_ls_issue_type_ls1_i1,     


  input wire  [`RV_BC_UID]                      is_ls_uid_ls1_i1,            
  input wire                                   is_ls_rid_ls1_i1, 
`ifdef VALIDATION
  input wire  [63:0]                           is_ls_instr_id_ls1_i1,       
`endif
  input wire  [`RV_BC_STID]                     is_ls_stid_ls1_i1,           
  input wire  [1:0]                            is_ls_srca_v_ls1_i2,         
  input wire  [63:0]                           is_ls_srca_data_ls1_i2,      

  input wire  [1:0]                            is_ls_srcb_v_ls1_i2,         
  input wire  [63:0]                           is_ls_srcb_data_ls1_i2,      

  input wire                                   is_ls_srcp_v_ls1_i2,         
  input wire  [3:0]                            is_ls_srcp_data_ls1_i2,      

  input wire  [15:1]                           is_ls_pc_ls1_i2,             

  input wire                                   is_ls_force_unchecked_ls1_i2, 

  input wire                                   ls1_ldg_ld_a1,
  input wire                                   ls1_ldgm_ld_a1,

  input wire                                   is_ls_srcpg_v_ls1_i2,       
  input wire [`RV_BC_LS_SVE_PRED_RANGE]         is_ls_srcpg_data_ls1_i2,    

  input wire [2:0]                             is_ls_dstx_vlreg_ls1_i2_q,    
  input wire [1:0]                             is_ls_dsty_vlreg_ls1_i2_q,    

  input wire                                   ls1_ld_ssbb_blk_i2,
  input wire                                   ls1_ld_ssbb_blk_a1_q,

  output reg [31:0]                           ls1_srcpg_data_a1,           
  output reg [31:0]                           ls1_srcpg_data_a2_q,         
  output reg                                  ls1_srcpg_v_a1_q,            
  output reg                                  ls1_srcpg_v_a2_q,            
  output wire                                  ls1_scatter_gather_v_i2,    
  
  output wire [31:0]                           ls1_parsed_pred_a1,
  output wire                                  ls1_lo_pred_non_zero_a1,     
  output wire                                  ls1_hi_pred_non_zero_a1,     
  output wire                                  ls1_pred_inv_force_ccfail_a1,  
  output wire                                  ls1_pred_all_inv_a1,  
  
  output wire                                  ff_or_nf_ld_ls1_a2,                               
  output wire                                  ff_ld_ls1_a2,                                     
  output reg [4:0]                            ffr_lane_ls1_a2_q,                                
  output wire                                  nf_ld_ls1_a2,                                     
  output wire                                  ff_cont_ld_ls1_a2,                                
  output wire                                  ff_gather_ld_ls1_a2,                              
  output wire                                  ffr_lane_eq_first_active_lane_ls1_a2,             
  output wire                                  first_vld_lane_found_ls1_a2,                      
  output wire                                  mid_first_lane_page_split_ls1_a2,                 
  output reg [1:0]                            ls1_ln_size_a2_q,                                 
  output wire                                  more_than_one_active_lane_ls1_a2,                 
  output wire [4:0]                            cont_ld_second_ffr_lane_ls1_a2,                   
  output wire                                  vld_split_lane_found_ls1_a1,                      
  input wire                                   ls1_sp_align_flt_a1,                              
  input wire                                   ls1_sp_align_flt_a2_q,                            
  output reg                                  chk_bit_ffr_upd_ls1_a2_q,                         
  output reg [4:0]                            chk_bit_ffr_lane_ls1_a2_q,                        
  
  output wire                                  ls1_empty_predicate,                              
  output wire                                  ls1_partial_predicate,                            
  

  output wire                                  issue_ld_val_possible_ls1_i2, 
  output wire                                  issue_pld_val_possible_ls1_i2, 
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls1_pc_index_i2,


  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls1_pc_index_a1_q,             
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls1_lpt_cam_pc_index_a1_q,     
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls1_lpt_cam_pc_index_dup_a1_q, 

  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls1_pc_index_a2_q,            

  input wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]     ls1_pc_index_d4,
  input wire                                   ls1_ld_vld_raw_haz_nuke_me_d4,  
  input wire                                   ls1_ld_vld_lpt_hit_d4,          
  input wire                                   ls1_ld_vld_sb_fwd_lpt_alloc_d4,              
  input wire                                   ls1_ld_uop_vld_d4,

  output reg                                  ls1_pf_trainable_type_a2_q,   
  input wire  [`RV_BC_LS_CTL]                   ls_uop_ctl_ls1_i2_q,          
  input wire                                   is_ls_issue_cancel_ls1_i1,   

  input wire                                   is_ls_dep_d3_resx_ls1_i1,    
  input wire                                   is_ls_dep_d3_resy_ls1_i1,

  input wire                                   is_ls_dep_d3_resz_ls1_i1,

  input wire                                   is_ls_issue_cancel_ls1_i2,         
  input wire                                   ls1_ld_reject_gather_i2,

  output wire [28:0]                           va_dup_ls1_a1,               
  output wire [3:0]                            va_adjust_ls1_a1,            

  output wire [5:0]                            end_byte_adjust_ls1_a1,      
  output reg                                  ls1_ld_cross_16_32_byte_a2_q,  
  output reg                                  ls1_ld_cross_32_byte_a2_q,   

  output reg                                  issue_v_ls1_i2_q,            
  output wire                                  issue_st_val_ls1_i2,         
  output wire                                  tmo_inject_val_ls1_i2,       
  output reg                                  address_inject_val_ls1_i2_q, 

  output reg                                  tmo_inject_val_ls1_a1_q,     
  output reg                                  tmo_inject_val_ls1_a2_q,     

  output wire                                  spe_inject_val_ls1_i2,       
  output reg                                  spe_inject_val_ls1_a1_q,     
  output reg                                  spe_inject_val_ls1_a2_q,     

  output wire                                  tbe_inject_val_ls1_i2,       
  output reg                                  tbe_inject_val_ls1_a1_q,     
  output reg                                  tbe_inject_val_ls1_a2_q,     


  output wire                                  pf_tlb_inject_v_ls1_i2,      
  output wire                                  pf_tlb_inject_v_ls1_a1,      
  output wire                                  pf_tlb_inject_v_ls1_a2,      
  output reg                                  address_inject_val_ls1_a1_q, 
  output reg                                  address_inject_val_ls1_a2_q, 

  output wire                                  issue_v_ls1_i2,              
  output wire                                  issue_v_early_ls1_i2,        
  output wire                                  issue_ld_val_ls1_i2,
  output wire                                  issue_ld_val_early_ls1_i2,
  output wire                                  tlb_cam_v_ld_st_ccpass_ls1_a1,              
  output wire                                  tlb_cam_v_ls1_a1,                           
  output wire                                  va_v_ls1_a1,                                
  output wire                                  unalign1_ls1_a1,             
  output reg [`RV_BC_UID]                      uid_ls1_i2_q,
  output reg                                  rid_ls1_i2_q,
`ifdef VALIDATION
  output reg  [63:0]                          instr_id_ls1_i2_q,           
`endif
  input wire                                   st_no_xlat_ls1_a1,           
  output reg [`RV_BC_STID]                     ls1_stid_i2_q,               

  output wire                                  ld_val_ls1_a1,
  output wire                                  st_val_ls1_a1,
  output reg                                  st_val_ls1_a2_q,
  output wire                                  unalign2_ls1_a1_q,              
  output wire                                  cache_line_split_ls1_a1,        
  output wire                                  st_cache_line_split_ls1_a1,  
  output wire                                  st_low_cache_line_split_ls1_a1,  
  output wire                                  st_mid_cache_line_split_ls1_a1,  
  output wire                                  st_hi_cache_line_split_ls1_a1,  
  output reg                                  srca_v_ls1_a1_q,             

  output reg                                  ld_val_ls1_arb_possible_a1_q,          

  output wire [5:0]                            end_byte_ls1_a1,             
  output wire [5:3]                            st_low_end_byte_ls1_a1,      
  output reg [`RV_BC_STID]                   stid_ls1_a1_q,               
  output wire [`RV_BC_LS_CTL]                 ls_uop_ctl_ls1_a1_q,        
  output wire                                  ls1_uop_cross_16_byte_a1,    
  output wire                                  ls_ctl_format_ls1_a1,        
  output wire                                  ccpass_ls1_a1,               
  output reg                                  ls1_ccpass_st_a2_q,          
  output wire                                  reject_unalign_ls1_a1,       

  output wire                                  iq1_gather_ld_i2,
  output reg                                  iq1_gather_ld_a1_q,
  output reg                                  iq1_gather_ld_a2_q,
  
  output wire                                  unalign2_ls1_i2,
  output reg                                  unalign2_ls1_a2_q,
  output reg [`RV_BC_STID]                   stid_ls1_a2_q,               

  output wire                                  ls1_ld_unalign1_a1,          
  output wire                                  ls1_ld_unalign1_qual_a1,     
  output wire                                  ls1_ld_unalign1_a2,

  output wire                                  ls1_ld_page_split1_a1,        
  output wire                                  ls1_ld_page_split1_a2,
  output wire                                  ls1_st_page_split1_a1,
  output wire                                  ls1_page_split1_val_a1,

  output wire                                  ls1_ld_unalign2_a1,          

  output wire                                  ls1_ld_page_split2_a1,        

  output wire                                  ls1_uop_flush_i2,

  output wire                                  ls_is_uop_reject_ls1_i2,     
  output wire                                  ls_is_uop_reject_ls1_d1, 
 
  output reg                                  ls1_page_split2_a1_q,

  output reg                                  ls1_page_split2_a2_q,

  output wire [15:0]                           wv_ls1_a1,                   
  output wire [7:0]                            bank_dec_ld_ls1_a1,          
                                                                         
   output wire [31:0]                          byte_access_map_ls1_a1,                                                                            



  input wire                                   is_ls_oldest_ld_v_ls2,
  input wire [`RV_BC_UID]                       is_ls_oldest_ld_uid_ls2,
  input wire                                   is_ls_oldest_ld_rid_ls2,

  input wire                                   is_ls_dstx_v_ls2_new_i2,
  input wire                                   is_ls_dstx_v_ls2_i2_q,
  input wire                                   is_ls_dsty_v_ls2_i2_q,

  output reg  [63:0]                          agu_addend_a_ls2_a1_q,
  output reg  [63:0]                          agu_addend_b_ls2_a1_q,

  input wire   [2:0]                           is_ls_dst_size_ls2_i2_q,
  
  input wire                                    ls2_ccpass_a2_q,
  input wire                                    ls2_iq_ld_dev_a2,
  
  output wire                                   ls2_type_ldg_i2,
  
  output reg                                   ls2_frc_unchecked_a1_q,

  output wire  [4:0]             ls2_srca_hash_a1,            
  output reg  [4:0]             ls2_srca_hash_a2_q,          

  output wire                                   ls2_sp_base_a1,              

  output reg                                   ls2_st_pf_on_rst_full_a1_q,  

  output wire                                  carry_in_ls2_a1_q,

  output reg                                  ls2_precommit_uop_a1_q, 

  input wire [63:0]                            ls2_cin_a1,
  input wire [63:0]                            va_ls2_a1,                   
  output wire                                  ls2_fast_cout11_a1,          

  input wire [11:0]                            va_ls2_a2_q,                 
  output wire [2:0]                            ls2_element_size_a1,         
  output reg                                  ls2_ld_unpred_sve_uop_a1_q,  
  output reg [4:0]                            bytes_to_page_split_ls2_a2_q,  
  output reg                                  ls2_valid_multi_reg_ld_st_op_a2_q,   
  input wire                                   valid_xlat_uop_ls2_a1,            
  output wire  [4:0]                           first_active_byte_ls2_a2,
  input wire   [2:0]                           ls2_element_size_a2,
  output reg  [31:0]                          cont_ld_ffr_lane_dec_ls2_a1,

  input wire                                   is_ls_issue_v_ls2_i1,        
  input wire                                   is_ls_issue_type_ls2_i1,     


  input wire  [`RV_BC_UID]                      is_ls_uid_ls2_i1,            
  input wire                                   is_ls_rid_ls2_i1, 
`ifdef VALIDATION
  input wire  [63:0]                           is_ls_instr_id_ls2_i1,       
`endif
  input wire  [`RV_BC_STID]                     is_ls_stid_ls2_i1,           
  input wire  [1:0]                            is_ls_srca_v_ls2_i2,         
  input wire  [63:0]                           is_ls_srca_data_ls2_i2,      

  input wire  [1:0]                            is_ls_srcb_v_ls2_i2,         
  input wire  [63:0]                           is_ls_srcb_data_ls2_i2,      

  input wire                                   is_ls_srcp_v_ls2_i2,         
  input wire  [3:0]                            is_ls_srcp_data_ls2_i2,      

  input wire  [15:1]                           is_ls_pc_ls2_i2,             

  input wire                                   is_ls_force_unchecked_ls2_i2, 

  input wire                                   ls2_ldg_ld_a1,
  input wire                                   ls2_ldgm_ld_a1,

  input wire                                   is_ls_srcpg_v_ls2_i2,       
  input wire [`RV_BC_LS_SVE_PRED_RANGE]         is_ls_srcpg_data_ls2_i2,    

  input wire [2:0]                             is_ls_dstx_vlreg_ls2_i2_q,    
  input wire [1:0]                             is_ls_dsty_vlreg_ls2_i2_q,    

  input wire                                   ls2_ld_ssbb_blk_i2,
  input wire                                   ls2_ld_ssbb_blk_a1_q,

  output reg [31:0]                           ls2_srcpg_data_a1,           
  output reg [31:0]                           ls2_srcpg_data_a2_q,         
  output reg                                  ls2_srcpg_v_a1_q,            
  output reg                                  ls2_srcpg_v_a2_q,            
  output wire                                  ls2_scatter_gather_v_i2,    
  
  output wire [31:0]                           ls2_parsed_pred_a1,
  output wire                                  ls2_lo_pred_non_zero_a1,     
  output wire                                  ls2_hi_pred_non_zero_a1,     
  output wire                                  ls2_pred_inv_force_ccfail_a1,  
  output wire                                  ls2_pred_all_inv_a1,  
  
  output wire                                  ff_or_nf_ld_ls2_a2,                               
  output wire                                  ff_ld_ls2_a2,                                     
  output reg [4:0]                            ffr_lane_ls2_a2_q,                                
  output wire                                  nf_ld_ls2_a2,                                     
  output wire                                  ff_cont_ld_ls2_a2,                                
  output wire                                  ff_gather_ld_ls2_a2,                              
  output wire                                  ffr_lane_eq_first_active_lane_ls2_a2,             
  output wire                                  first_vld_lane_found_ls2_a2,                      
  output wire                                  mid_first_lane_page_split_ls2_a2,                 
  output reg [1:0]                            ls2_ln_size_a2_q,                                 
  output wire                                  more_than_one_active_lane_ls2_a2,                 
  output wire [4:0]                            cont_ld_second_ffr_lane_ls2_a2,                   
  output wire                                  vld_split_lane_found_ls2_a1,                      
  input wire                                   ls2_sp_align_flt_a1,                              
  input wire                                   ls2_sp_align_flt_a2_q,                            
  output reg                                  chk_bit_ffr_upd_ls2_a2_q,                         
  output reg [4:0]                            chk_bit_ffr_lane_ls2_a2_q,                        
  
  output wire                                  ls2_empty_predicate,                              
  output wire                                  ls2_partial_predicate,                            
  

  output wire                                  issue_ld_val_possible_ls2_i2, 
  output wire                                  issue_pld_val_possible_ls2_i2, 
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls2_pc_index_i2,


  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls2_pc_index_a1_q,             
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls2_lpt_cam_pc_index_a1_q,     
  output wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls2_lpt_cam_pc_index_dup_a1_q, 

  output reg [`RV_BC_LS_LPT_PC_INDEX_MAX:0]    ls2_pc_index_a2_q,            

  input wire [`RV_BC_LS_LPT_PC_INDEX_MAX:0]     ls2_pc_index_d4,
  input wire                                   ls2_ld_vld_raw_haz_nuke_me_d4,  
  input wire                                   ls2_ld_vld_lpt_hit_d4,          
  input wire                                   ls2_ld_vld_sb_fwd_lpt_alloc_d4,              
  input wire                                   ls2_ld_uop_vld_d4,

  output reg                                  ls2_pf_trainable_type_a2_q,   
  input wire  [`RV_BC_LS_CTL]                   ls_uop_ctl_ls2_i2_q,          
  input wire                                   is_ls_issue_cancel_ls2_i1,   

  input wire                                   is_ls_dep_d3_resx_ls2_i1,    
  input wire                                   is_ls_dep_d3_resy_ls2_i1,

  input wire                                   is_ls_dep_d3_resz_ls2_i1,

  input wire                                   is_ls_issue_cancel_ls2_i2,         
  input wire                                   ls2_ld_reject_gather_i2,

  output wire [28:0]                           va_dup_ls2_a1,               
  output wire [3:0]                            va_adjust_ls2_a1,            

  output wire [5:0]                            end_byte_adjust_ls2_a1,      
  output reg                                  ls2_ld_cross_16_32_byte_a2_q,  
  output reg                                  ls2_ld_cross_32_byte_a2_q,   

  output reg                                  issue_v_ls2_i2_q,            
  output wire                                  issue_st_val_ls2_i2,         
  output wire                                  tmo_inject_val_ls2_i2,       
  output reg                                  address_inject_val_ls2_i2_q, 

  output reg                                  tmo_inject_val_ls2_a1_q,     
  output reg                                  tmo_inject_val_ls2_a2_q,     

  output wire                                  spe_inject_val_ls2_i2,       
  output reg                                  spe_inject_val_ls2_a1_q,     
  output reg                                  spe_inject_val_ls2_a2_q,     

  output wire                                  tbe_inject_val_ls2_i2,       
  output reg                                  tbe_inject_val_ls2_a1_q,     
  output reg                                  tbe_inject_val_ls2_a2_q,     


  output wire                                  pf_tlb_inject_v_ls2_i2,      
  output wire                                  pf_tlb_inject_v_ls2_a1,      
  output wire                                  pf_tlb_inject_v_ls2_a2,      
  output reg                                  address_inject_val_ls2_a1_q, 
  output reg                                  address_inject_val_ls2_a2_q, 

  output wire                                  issue_v_ls2_i2,              
  output wire                                  issue_v_early_ls2_i2,        
  output wire                                  issue_ld_val_ls2_i2,
  output wire                                  issue_ld_val_early_ls2_i2,
  output wire                                  tlb_cam_v_ld_st_ccpass_ls2_a1,              
  output wire                                  tlb_cam_v_ls2_a1,                           
  output wire                                  va_v_ls2_a1,                                
  output wire                                  unalign1_ls2_a1,             
  output reg [`RV_BC_UID]                      uid_ls2_i2_q,
  output reg                                  rid_ls2_i2_q,
`ifdef VALIDATION
  output reg  [63:0]                          instr_id_ls2_i2_q,           
`endif
  input wire                                   st_no_xlat_ls2_a1,           
  output reg [`RV_BC_STID]                     ls2_stid_i2_q,               

  output wire                                  ld_val_ls2_a1,
  output wire                                  st_val_ls2_a1,
  output reg                                  st_val_ls2_a2_q,
  output wire                                  unalign2_ls2_a1_q,              
  output wire                                  cache_line_split_ls2_a1,        
  output wire                                  st_cache_line_split_ls2_a1,  
  output wire                                  st_low_cache_line_split_ls2_a1,  
  output wire                                  st_mid_cache_line_split_ls2_a1,  
  output wire                                  st_hi_cache_line_split_ls2_a1,  
  output reg                                  srca_v_ls2_a1_q,             

  output reg                                  ld_val_ls2_arb_possible_a1_q,          

  output wire [5:0]                            end_byte_ls2_a1,             
  output wire [5:3]                            st_low_end_byte_ls2_a1,      
  output reg [`RV_BC_STID]                   stid_ls2_a1_q,               
  output wire [`RV_BC_LS_CTL]                 ls_uop_ctl_ls2_a1_q,        
  output wire                                  ls2_uop_cross_16_byte_a1,    
  output wire                                  ls_ctl_format_ls2_a1,        
  output wire                                  ccpass_ls2_a1,               
  output reg                                  ls2_ccpass_st_a2_q,          
  output wire                                  reject_unalign_ls2_a1,       

  output wire                                  iq2_gather_ld_i2,
  output reg                                  iq2_gather_ld_a1_q,
  output reg                                  iq2_gather_ld_a2_q,
  
  output wire                                  unalign2_ls2_i2,
  output reg                                  unalign2_ls2_a2_q,
  output reg [`RV_BC_STID]                   stid_ls2_a2_q,               

  output wire                                  ls2_ld_unalign1_a1,          
  output wire                                  ls2_ld_unalign1_qual_a1,     
  output wire                                  ls2_ld_unalign1_a2,

  output wire                                  ls2_ld_page_split1_a1,        
  output wire                                  ls2_ld_page_split1_a2,
  output wire                                  ls2_st_page_split1_a1,
  output wire                                  ls2_page_split1_val_a1,

  output wire                                  ls2_ld_unalign2_a1,          

  output wire                                  ls2_ld_page_split2_a1,        

  output wire                                  ls2_uop_flush_i2,

  output wire                                  ls_is_uop_reject_ls2_i2,     
  output wire                                  ls_is_uop_reject_ls2_d1, 
 
  output reg                                  ls2_page_split2_a1_q,

  output reg                                  ls2_page_split2_a2_q,

  output wire [15:0]                           wv_ls2_a1,                   
  output wire [7:0]                            bank_dec_ld_ls2_a1,          
                                                                         
   output wire [31:0]                          byte_access_map_ls2_a1,                                                                            

  input wire                                   any_lpt_valid_ent_21_to_max,    
  output wire                                  any_issue_v_a1,                
  output wire                                  any_issue_v_i2,                
  output wire                                  ls0_uop_older_than_ls1_i2,     
  output wire                                  ls0_uop_older_than_ls2_i2,     
  output wire                                  ls1_uop_older_than_ls2_i2,     
  output reg                                  ls0_uop_older_than_ls1_a2_q,   
  output reg                                  ls0_uop_older_than_ls1_a1_q,   
  output reg                                  ls0_uop_older_than_ls2_a1_q,   
  output reg                                  ls1_uop_older_than_ls2_a1_q,   

  output wire                                  sb_addr_wr_poss_din,           
  input wire                                   wr_sb_rst_ptr_stall_r2,        
  input wire                                   prevent_st_issue_pf,           

  input wire                                   ls_is_resx_cancel_d4,          
  input wire                                   ls_is_resy_cancel_d4,          
  input wire                                   ls_is_resz_cancel_d4,          

  input wire                                   ls_ff_nf_ld_ffr_upd_always                ,      
  input wire                                   ls_ff_nf_ld_ffr_cons_upd_on_exptn         ,      
  input wire                                   ls_unalign_ff_ld_ffr_cons_upd_on_exptn    ,      
  input wire                                   ls_unalign_nf_ld_ffr_cons_upd_on_exptn    ,      
  input wire                                   ls_page_split_ff_ld_ffr_cons_upd_on_exptn ,      
  input wire                                   ls_page_split_nf_ld_ffr_cons_upd_on_exptn ,      


  input wire                                   flush,                         
  input wire [`RV_BC_UID]                     flush_uid,

  input wire                                   cpsr_aarch32                   

);







  wire                                   addr_inject_en;
  wire                                   addr_inject_outstanding_in;
  reg                                    addr_inject_outstanding_q;
  wire                                   addr_injected_i2_qual;
  wire                                   address_inject_val_ls0_i1;
  wire                                   address_inject_val_ls1_i1;
  wire                                   address_inject_val_ls2_i1;
  wire [5:0]                             adjust_va_ls0_a1;
  wire [5:0]                             adjust_va_ls1_a1;
  wire [5:0]                             adjust_va_ls2_a1;
  wire                                   agu_addend_a_dup_en_ls0_i2;
  wire                                   agu_addend_a_dup_en_ls1_i2;
  wire                                   agu_addend_a_dup_en_ls2_i2;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_a_dup_ls0_a1_q;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_a_dup_ls1_a1_q;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_a_dup_ls2_a1_q;
  wire [1:0]                             agu_addend_a_en_ls0_i2;
  wire [1:0]                             agu_addend_a_en_ls1_i2;
  wire [1:0]                             agu_addend_a_en_ls2_i2;
  wire [63:0]                            agu_addend_a_ls0_i2;
  wire [63:0]                            agu_addend_a_ls1_i2;
  wire [63:0]                            agu_addend_a_ls2_i2;
  wire                                   agu_addend_b_dup_en_ls0_i2;
  wire                                   agu_addend_b_dup_en_ls1_i2;
  wire                                   agu_addend_b_dup_en_ls2_i2;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_b_dup_ls0_a1_q;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_b_dup_ls1_a1_q;
  wire [(L1_DCACHE_VA_BITS+11):0]        agu_addend_b_dup_ls2_a1_q;
  wire [1:0]                             agu_addend_b_en_ls0_i2;
  wire [1:0]                             agu_addend_b_en_ls1_i2;
  wire [1:0]                             agu_addend_b_en_ls2_i2;
  wire [63:0]                            agu_addend_b_ls0_i2;
  wire [63:0]                            agu_addend_b_ls1_i2;
  wire [63:0]                            agu_addend_b_ls2_i2;
  wire                                   agu_rcg_ls0_i2_din;
  reg                                    agu_rcg_ls0_i2_q;
  wire                                   agu_rcg_ls1_i2_din;
  reg                                    agu_rcg_ls1_i2_q;
  wire                                   agu_rcg_ls2_i2_din;
  reg                                    agu_rcg_ls2_i2_q;
  wire                                   any_issue_v_i2_a2;
  wire                                   any_issue_v_ls0_i2_a2;
  wire                                   any_issue_v_ls1_i2_a2;
  wire                                   any_issue_v_ls2_i2_a2;
  wire                                   any_req_waiting_cnt_saturated_in;
  reg                                    any_req_waiting_cnt_saturated_q;
  wire                                   any_rr_find_first;
  wire                                   any_rr_find_first_masked;
  reg                                    blk_non_oldest_ld_q;
  wire [31:0]                            byte_access_map_pre_ls0_a1;
  wire [31:0]                            byte_access_map_pre_ls1_a1;
  wire [31:0]                            byte_access_map_pre_ls2_a1;
  reg  [31:0]                            byte_access_map_pre_pg_split_ls0_a1;
  reg  [31:0]                            byte_access_map_pre_pg_split_ls1_a1;
  reg  [31:0]                            byte_access_map_pre_pg_split_ls2_a1;
  wire [31:0]                            byte_access_map_split_adjusted_ls0_a1;
  wire [31:0]                            byte_access_map_split_adjusted_ls1_a1;
  wire [31:0]                            byte_access_map_split_adjusted_ls2_a1;
  wire [4:0]                             bytes_to_cache_split_ls0_a1;
  wire [4:0]                             bytes_to_cache_split_ls1_a1;
  wire [4:0]                             bytes_to_cache_split_ls2_a1;
  wire [4:0]                             bytes_to_page_split_ls0_a1;
  wire [4:0]                             bytes_to_page_split_ls1_a1;
  wire [4:0]                             bytes_to_page_split_ls2_a1;
  wire                                   carry_in_dup_ls0_a1_q;
  wire                                   carry_in_dup_ls1_a1_q;
  wire                                   carry_in_dup_ls2_a1_q;
  wire                                   carry_in_ls0_i2;
  wire                                   carry_in_ls1_i2;
  wire                                   carry_in_ls2_i2;
  wire                                   chk_bit_ff_ld_ffr_upd_poss_ls0_a1;
  wire                                   chk_bit_ff_ld_ffr_upd_poss_ls1_a1;
  wire                                   chk_bit_ff_ld_ffr_upd_poss_ls2_a1;
  wire [4:0]                             chk_bit_ffr_lane_ls0_a1;
  wire [4:0]                             chk_bit_ffr_lane_ls1_a1;
  wire [4:0]                             chk_bit_ffr_lane_ls2_a1;
  wire                                   chk_bit_ffr_upd_clk_en_ls0_a1;
  wire                                   chk_bit_ffr_upd_clk_en_ls1_a1;
  wire                                   chk_bit_ffr_upd_clk_en_ls2_a1;
  wire                                   chk_bit_ffr_upd_ls0_a1;
  wire                                   chk_bit_ffr_upd_ls1_a1;
  wire                                   chk_bit_ffr_upd_ls2_a1;
  wire                                   chk_bit_nf_ld_ffr_upd_poss_ls0_a1;
  wire                                   chk_bit_nf_ld_ffr_upd_poss_ls1_a1;
  wire                                   chk_bit_nf_ld_ffr_upd_poss_ls2_a1;
  wire                                   clk_agu0;
  wire                                   clk_agu1;
  wire                                   clk_agu2;
  reg  [4:0]                             cont_ld_ffr_lane_ls0_a1;
  reg  [4:0]                             cont_ld_ffr_lane_ls1_a1;
  reg  [4:0]                             cont_ld_ffr_lane_ls2_a1;
  reg  [31:0]                            cont_ld_last_lane_dec_ls0_a1;
  reg  [31:0]                            cont_ld_last_lane_dec_ls1_a1;
  reg  [31:0]                            cont_ld_last_lane_dec_ls2_a1;
  reg  [31:0]                            contiguous_lane_vlds_ls0_a1;
  reg  [31:0]                            contiguous_lane_vlds_ls1_a1;
  reg  [31:0]                            contiguous_lane_vlds_ls2_a1;
  reg                                    dep_d4_resx_ls0_i2_q;
  reg                                    dep_d4_resx_ls1_i2_q;
  reg                                    dep_d4_resx_ls2_i2_q;
  reg                                    dep_d4_resy_ls0_i2_q;
  reg                                    dep_d4_resy_ls1_i2_q;
  reg                                    dep_d4_resy_ls2_i2_q;
  reg                                    dep_d4_resz_ls0_i2_q;
  reg                                    dep_d4_resz_ls1_i2_q;
  reg                                    dep_d4_resz_ls2_i2_q;
  reg                                    disable_iq_ld_arb_q;
  wire                                   disable_iq_ld_pipe0_arb;
  wire                                   disable_iq_ld_pipe1_arb;
  wire                                   disable_iq_ld_pipe2_arb;
  wire                                   end_byte_carry_out_2_ls0_a1;
  wire                                   end_byte_carry_out_2_ls1_a1;
  wire                                   end_byte_carry_out_2_ls2_a1;
  wire                                   end_byte_carry_out_5_ls0_a1;
  wire                                   end_byte_carry_out_5_ls1_a1;
  wire                                   end_byte_carry_out_5_ls2_a1;
  wire                                   unit_fault_only_first_ld_ls0_a1;
  reg                                    ff_cont_ld_ls0_a2_q;
  wire                                   ff_cont_ld_ls1_a1;
  reg                                    ff_cont_ld_ls1_a2_q;
  wire                                   ff_cont_ld_ls2_a1;
  reg                                    ff_cont_ld_ls2_a2_q;
  wire                                   gather_fault_only_first_ld_ls0_a1;
  reg                                    ff_gather_ld_ls0_a2_q;
  wire                                   ff_gather_ld_ls1_a1;
  reg                                    ff_gather_ld_ls1_a2_q;
  wire                                   ff_gather_ld_ls2_a1;
  reg                                    ff_gather_ld_ls2_a2_q;
  wire                                   ff_ld_ls0_a1;
  wire                                   ff_ld_ls1_a1;
  wire                                   ff_ld_ls2_a1;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls0_a1;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls0_a2;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls1_a1;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls1_a2;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls2_a1;
  wire                                   ff_or_nf_ld_a2_flops_clk_en_ls2_a2;
  reg                                    ffr_lane_eq_first_active_lane_ls0_a3_q;
  reg                                    ffr_lane_eq_first_active_lane_ls1_a3_q;
  reg                                    ffr_lane_eq_first_active_lane_ls2_a3_q;
  wire [4:0]                             ffr_lane_ls0_a1;
  wire [4:0]                             ffr_lane_ls1_a1;
  wire [4:0]                             ffr_lane_ls2_a1;
  wire [31:0]                            ffr_vlds_ls0_a1;
  wire [31:0]                            ffr_vlds_ls1_a1;
  wire [31:0]                            ffr_vlds_ls2_a1;
  reg                                    first_active_byte_found_ls0_a1;
  reg                                    first_active_byte_found_ls1_a1;
  reg                                    first_active_byte_found_ls2_a1;
  reg  [4:0]                             first_active_byte_ls0_a1;
  reg  [4:0]                             first_active_byte_ls1_a1;
  reg  [4:0]                             first_active_byte_ls2_a1;
  reg  [4:0]                             first_active_byte_pre_ls0_a1;
  reg  [4:0]                             first_active_byte_pre_ls1_a1;
  reg  [4:0]                             first_active_byte_pre_ls2_a1;
  wire [7:0]                             first_bank_dec_ld_ls0_a1;
  wire [7:0]                             first_bank_dec_ld_ls1_a1;
  wire [7:0]                             first_bank_dec_ld_ls2_a1;
  reg                                    first_one_found_ls0_a2;
  reg                                    first_one_found_ls1_a2;
  reg                                    first_one_found_ls2_a2;
  wire                                   first_vld_lane_found_ls0_a1;
  reg                                    first_vld_lane_found_ls0_a2_q;
  reg                                    first_vld_lane_found_ls0_a3_q;
  wire                                   first_vld_lane_found_ls1_a1;
  reg                                    first_vld_lane_found_ls1_a2_q;
  reg                                    first_vld_lane_found_ls1_a3_q;
  wire                                   first_vld_lane_found_ls2_a1;
  reg                                    first_vld_lane_found_ls2_a2_q;
  reg                                    first_vld_lane_found_ls2_a3_q;
  wire                                   flip_bubble_toggle;
  wire                                   ici_val_ls0_a1;
  reg                                    ici_val_ls0_a2_q;
  wire                                   ici_val_ls1_a1;
  reg                                    ici_val_ls1_a2_q;
  wire                                   ici_val_ls2_a1;
  reg                                    ici_val_ls2_a2_q;
  wire                                   inj_counter_clear;
  wire                                   inj_counter_en;
  wire                                   inj_counter_incr;
  wire [3:0]                             inject_cycle_counter_in;
  reg  [3:0]                             inject_cycle_counter_q;
  wire                                   injection_sel_pref;
  wire                                   injection_sel_pref_skid;
  wire                                   injection_sel_spe;
  wire                                   injection_sel_tbe;
  wire                                   injection_sel_tmo;
  wire [1:0]                             is_ls_dsty_vlreg_ls0_i2;
  wire [1:0]                             is_ls_dsty_vlreg_ls1_i2;
  wire [1:0]                             is_ls_dsty_vlreg_ls2_i2;
  wire                                   is_ls_srcpg_v_ls0_qual_i2;
  wire                                   is_ls_srcpg_v_ls1_qual_i2;
  wire                                   is_ls_srcpg_v_ls2_qual_i2;
  wire                                   issue_cancel_ls0_i2;
  reg                                    issue_cancel_ls0_i2_dly_q;
  wire                                   issue_cancel_ls1_i2;
  reg                                    issue_cancel_ls1_i2_dly_q;
  wire                                   issue_cancel_ls2_i2;
  reg                                    issue_cancel_ls2_i2_dly_q;
  reg                                    issue_ici_val_ls0_a1_q;
  wire                                   issue_ici_val_ls0_i2;
  reg                                    issue_ici_val_ls1_a1_q;
  wire                                   issue_ici_val_ls1_i2;
  reg                                    issue_ici_val_ls2_a1_q;
  wire                                   issue_ici_val_ls2_i2;
  wire                                   issue_iciall_val_ls0_i2;
  wire                                   issue_iciall_val_ls1_i2;
  wire                                   issue_iciall_val_ls2_i2;
  wire                                   issue_iciva_val_ls0_i2;
  wire                                   issue_iciva_val_ls1_i2;
  wire                                   issue_iciva_val_ls2_i2;
  wire                                   issue_ld_val_ls0_a1;
  reg                                    issue_ld_val_ls0_a1_q;
  wire                                   issue_ld_val_ls1_a1;
  reg                                    issue_ld_val_ls1_a1_q;
  wire                                   issue_ld_val_ls2_a1;
  reg                                    issue_ld_val_ls2_a1_q;
  wire                                   issue_st_val_ls0_a1;
  wire                                   issue_st_val_ls0_a1_din;
  reg                                    issue_st_val_ls0_a1_q;
  wire                                   issue_st_val_ls1_a1;
  wire                                   issue_st_val_ls1_a1_din;
  reg                                    issue_st_val_ls1_a1_q;
  wire                                   issue_st_val_ls2_a1;
  wire                                   issue_st_val_ls2_a1_din;
  reg                                    issue_st_val_ls2_a1_q;
  wire                                   issue_v_ls0_i1;
  wire                                   issue_v_ls1_i1;
  wire                                   issue_v_ls2_i1;
  wire                                   issue_v_poss_ls0_i2;
  wire                                   issue_v_poss_ls1_i2;
  wire                                   issue_v_poss_ls2_i2;
  reg  [4:0]                             lanes_to_page_split_ls0_a2;
  reg  [4:0]                             lanes_to_page_split_ls1_a2;
  reg  [4:0]                             lanes_to_page_split_ls2_a2;
  wire                                   last_bubble_injected_ls1_in;
  reg                                    last_bubble_injected_ls1_q;
  reg                                    ld_val_ls0_a2_q;
  wire                                   ld_val_ls0_arb_possible_i2;
  wire                                   ld_val_ls0_clken_a1;
  reg                                    ld_val_ls1_a2_q;
  wire                                   ld_val_ls1_arb_possible_i2;
  wire                                   ld_val_ls1_clken_a1;
  reg                                    ld_val_ls2_a2_q;
  wire                                   ld_val_ls2_arb_possible_i2;
  wire                                   ld_val_ls2_clken_a1;
  wire                                   lpt_cam_pc_index_l0_en_i2;
  wire                                   lpt_cam_pc_index_l1_en_i2;
  wire                                   lpt_cam_pc_index_l2_en_i2;
  wire                                   ls0_32byte_ld_st_cache_line_split_2nd_half_a1;
  reg                                    ls0_a1_reject_a1_q;
  wire                                   ls0_a1_reject_i2;
  wire [1:0]                             ls0_bk_pg_1_0;
  wire [1:0]                             ls0_bk_pg_2_1;
  wire [1:0]                             ls0_bk_pg_3_2;
  wire [1:0]                             ls0_bk_pg_4_1;
  wire [1:0]                             ls0_bk_pg_4_3;
  wire [5:3]                             ls0_bnk_dec_needed_cin_0_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_1_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_2_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_3_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_4_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_5_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_6_a1;
  wire [5:3]                             ls0_bnk_dec_needed_cin_7_a1;
  wire                                   ls0_cache_split1_val_a1;
  reg                                    ls0_cache_split2_a1_q;
  wire                                   ls0_ccpass_st_mod_a1;
  wire                                   ls0_cin_0_a1;
  reg  [4:0]                             ls0_cin_hash_a1_raw;
  wire [3:0]                             ls0_compact_pred_el_ln_size_b_d_a1;
  wire [15:0]                            ls0_compact_pred_el_ln_size_b_h_a1;
  wire [7:0]                             ls0_compact_pred_el_ln_size_b_w_a1;
  wire [7:0]                             ls0_compact_pred_el_ln_size_h_d_a1;
  wire [15:0]                            ls0_compact_pred_el_ln_size_h_w_a1;
  wire [15:0]                            ls0_compact_pred_el_ln_size_w_d_a1;
  wire [31:0]                            ls0_cont_parsed_pred_a1;
  wire [5:0]                             ls0_cout_a1;
  wire                                   ls0_el_ln_size_b_d_a1;
  wire                                   ls0_el_ln_size_b_h_a1;
  wire                                   ls0_el_ln_size_b_w_a1;
  wire                                   ls0_el_ln_size_eq_a1;
  wire                                   ls0_el_ln_size_h_d_a1;
  wire                                   ls0_el_ln_size_h_w_a1;
  wire                                   ls0_el_ln_size_w_d_a1;
  wire [11:0]                            ls0_fast_va_a1;
  wire [5:0]                             ls0_g_a1;
  wire                                   ls0_hi_pred_zero_a1;
  wire                                   ls0_ld2_st2_a1;
  wire [31:0]                            ls0_ld2_st2_parsed_pred_a1_uop0;
  wire [31:0]                            ls0_ld2_st2_parsed_pred_a1_uop1;
  wire [15:0]                            ls0_ld2_st2_parsed_pred_a1_uop1_vl16;
  wire                                   ls0_ld3_st3_a1;
  wire [31:0]                            ls0_ld3_st3_parsed_pred_a1_uop0;
  wire [31:0]                            ls0_ld3_st3_parsed_pred_a1_uop1;
  wire [15:0]                            ls0_ld3_st3_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls0_ld3_st3_parsed_pred_a1_uop2;
  wire [15:0]                            ls0_ld3_st3_parsed_pred_a1_uop2_vl16;
  wire                                   ls0_ld4_st4_a1;
  wire [31:0]                            ls0_ld4_st4_parsed_pred_a1_uop0;
  wire [31:0]                            ls0_ld4_st4_parsed_pred_a1_uop1;
  wire [15:0]                            ls0_ld4_st4_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls0_ld4_st4_parsed_pred_a1_uop2;
  wire [15:0]                            ls0_ld4_st4_parsed_pred_a1_uop2_vl16;
  wire [31:0]                            ls0_ld4_st4_parsed_pred_a1_uop3;
  wire [15:0]                            ls0_ld4_st4_parsed_pred_a1_uop3_vl16;
  wire                                   ls0_ld_cross_16_32_byte_a1;
  wire                                   ls0_ld_reject_gather_nxt_i2;
  reg  [31:0]                            ls0_ld_st_multi_reg_parsed_pred_a1;
  wire                                   ls0_ld_unpred_sve_uop_i2;
  wire                                   ls0_ldpx_type_i2;
  reg  [1:0]                             ls0_ln_size_a1_q;
  wire                                   ls0_lo_pred_zero_a1;
  wire                                   ls0_lpt_cam_pc_index_clk_en_i2_d4;
  wire [13:0]                            ls0_lpt_cam_pc_index_i2;
  wire [1:0]                             ls0_multi_reg_ld_st_op_a1;
  wire                                   ls0_non_sized_a1;
  wire [5:0]                             ls0_p_a1;
  wire                                   ls0_page_split1_a1;
  wire                                   ls0_page_split1_early_val_a1;
  wire [31:0]                            ls0_parsed_pred_adjusted_a1;
  wire [31:0]                            ls0_parsed_pred_adjusted_masked_a1;
  wire [31:0]                            ls0_parsed_pred_split_adjusted_a1;
  wire [31:0]                            ls0_parsed_pred_split_adjusted_masked_a1;
  wire                                   ls0_pc_index_clken_a1;
  wire                                   ls0_pf_trainable_type_a1;
  wire                                   ls0_precommit_uop_i2;
  wire                                   ls0_precommit_uop_i2_unqual;
  wire                                   ls0_precommit_uop_reject;
  wire                                   ls0_precommit_uop_reject_cnt_clr;
  reg  [15:0]                            ls0_pred_mask;
  wire                                   ls0_qrep_ld_a1;
  wire                                   ls0_rep_ld_a1;
  reg                                    ls0_rep_ld_a2_q;
  wire                                   ls0_rep_pred_zero_a1;
  reg  [2:0]                             ls0_scatter_gather_ln_num_a1_q;
  reg  [7:0]                             ls0_scatter_gather_parsed_pred_a1;
  reg                                    ls0_scatter_gather_v_a1_q;
  reg                                    ls0_scatter_gather_v_a2_q;
  wire                                   ls0_spe_part_pg_non_qrep;
  wire                                   ls0_spe_part_pg_rep_qrep;
  wire                                   ls0_spe_part_pg_uop;
  wire                                   ls0_spe_part_pg_uop_qrep;
  wire                                   ls0_spe_zero_pg_non_qrep;
  wire                                   ls0_spe_zero_pg_rep_qrep;
  wire                                   ls0_spe_zero_pg_uop;
  wire [5:0]                             ls0_split_adjusted_access_size_a1;
  reg  [4:0]                             ls0_srca_hash_a1_raw;
  wire [4:0]                             ls0_srca_hash_final_a1;
  reg  [4:0]                             ls0_srcb_hash_a1_raw;
  reg  [31:0]                            ls0_srcpg_data_a1_q;
  wire [31:0]                            ls0_srcpg_data_i2;
  wire [31:0]                            ls0_srcpg_data_pq_a1;
  wire                                   ls0_st_page_split1_a2;
  wire                                   ls0_st_pf_on_rst_full_i2;
  wire                                   ls0_st_pf_on_rst_full_poss_i2;
  wire                                   ls0_thumb_instr_i2;
  wire                                   ls0_uop_cross_32_byte_a1;
  wire [1:0]                             ls0_uop_num_a1;
  wire                                   ls0_uop_size_16byte_a1;
  wire                                   ls0_uop_size_32byte_a1;
  wire                                   ls0_valid_multi_reg_ld_st_op_a1;
  wire                                   ls0_vl16_a1;
  wire                                   ls1_32byte_ld_st_cache_line_split_2nd_half_a1;
  reg                                    ls1_a1_reject_a1_q;
  wire                                   ls1_a1_reject_i2;
  wire [1:0]                             ls1_bk_pg_1_0;
  wire [1:0]                             ls1_bk_pg_2_1;
  wire [1:0]                             ls1_bk_pg_3_2;
  wire [1:0]                             ls1_bk_pg_4_1;
  wire [1:0]                             ls1_bk_pg_4_3;
  wire [5:3]                             ls1_bnk_dec_needed_cin_0_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_1_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_2_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_3_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_4_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_5_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_6_a1;
  wire [5:3]                             ls1_bnk_dec_needed_cin_7_a1;
  wire                                   ls1_cache_split1_val_a1;
  reg                                    ls1_cache_split2_a1_q;
  wire                                   ls1_ccpass_st_mod_a1;
  wire                                   ls1_cin_0_a1;
  reg  [4:0]                             ls1_cin_hash_a1_raw;
  wire [3:0]                             ls1_compact_pred_el_ln_size_b_d_a1;
  wire [15:0]                            ls1_compact_pred_el_ln_size_b_h_a1;
  wire [7:0]                             ls1_compact_pred_el_ln_size_b_w_a1;
  wire [7:0]                             ls1_compact_pred_el_ln_size_h_d_a1;
  wire [15:0]                            ls1_compact_pred_el_ln_size_h_w_a1;
  wire [15:0]                            ls1_compact_pred_el_ln_size_w_d_a1;
  wire [31:0]                            ls1_cont_parsed_pred_a1;
  wire [5:0]                             ls1_cout_a1;
  wire                                   ls1_el_ln_size_b_d_a1;
  wire                                   ls1_el_ln_size_b_h_a1;
  wire                                   ls1_el_ln_size_b_w_a1;
  wire                                   ls1_el_ln_size_eq_a1;
  wire                                   ls1_el_ln_size_h_d_a1;
  wire                                   ls1_el_ln_size_h_w_a1;
  wire                                   ls1_el_ln_size_w_d_a1;
  wire [11:0]                            ls1_fast_va_a1;
  wire [5:0]                             ls1_g_a1;
  wire                                   ls1_hi_pred_zero_a1;
  wire                                   ls1_ld2_st2_a1;
  wire [31:0]                            ls1_ld2_st2_parsed_pred_a1_uop0;
  wire [31:0]                            ls1_ld2_st2_parsed_pred_a1_uop1;
  wire [15:0]                            ls1_ld2_st2_parsed_pred_a1_uop1_vl16;
  wire                                   ls1_ld3_st3_a1;
  wire [31:0]                            ls1_ld3_st3_parsed_pred_a1_uop0;
  wire [31:0]                            ls1_ld3_st3_parsed_pred_a1_uop1;
  wire [15:0]                            ls1_ld3_st3_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls1_ld3_st3_parsed_pred_a1_uop2;
  wire [15:0]                            ls1_ld3_st3_parsed_pred_a1_uop2_vl16;
  wire                                   ls1_ld4_st4_a1;
  wire [31:0]                            ls1_ld4_st4_parsed_pred_a1_uop0;
  wire [31:0]                            ls1_ld4_st4_parsed_pred_a1_uop1;
  wire [15:0]                            ls1_ld4_st4_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls1_ld4_st4_parsed_pred_a1_uop2;
  wire [15:0]                            ls1_ld4_st4_parsed_pred_a1_uop2_vl16;
  wire [31:0]                            ls1_ld4_st4_parsed_pred_a1_uop3;
  wire [15:0]                            ls1_ld4_st4_parsed_pred_a1_uop3_vl16;
  wire                                   ls1_ld_cross_16_32_byte_a1;
  wire                                   ls1_ld_reject_gather_nxt_i2;
  reg  [31:0]                            ls1_ld_st_multi_reg_parsed_pred_a1;
  wire                                   ls1_ld_unpred_sve_uop_i2;
  wire                                   ls1_ldpx_type_i2;
  reg  [1:0]                             ls1_ln_size_a1_q;
  wire                                   ls1_lo_pred_zero_a1;
  wire                                   ls1_lpt_cam_pc_index_clk_en_i2_d4;
  wire [13:0]                            ls1_lpt_cam_pc_index_i2;
  wire [1:0]                             ls1_multi_reg_ld_st_op_a1;
  wire                                   ls1_non_sized_a1;
  wire [5:0]                             ls1_p_a1;
  wire                                   ls1_page_split1_a1;
  wire                                   ls1_page_split1_early_val_a1;
  wire [31:0]                            ls1_parsed_pred_adjusted_a1;
  wire [31:0]                            ls1_parsed_pred_adjusted_masked_a1;
  wire [31:0]                            ls1_parsed_pred_split_adjusted_a1;
  wire [31:0]                            ls1_parsed_pred_split_adjusted_masked_a1;
  wire                                   ls1_pc_index_clken_a1;
  wire                                   ls1_pf_trainable_type_a1;
  wire                                   ls1_precommit_uop_i2;
  wire                                   ls1_precommit_uop_i2_unqual;
  wire                                   ls1_precommit_uop_reject;
  wire                                   ls1_precommit_uop_reject_cnt_clr;
  reg  [15:0]                            ls1_pred_mask;
  wire                                   ls1_qrep_ld_a1;
  wire                                   ls1_rep_ld_a1;
  reg                                    ls1_rep_ld_a2_q;
  wire                                   ls1_rep_pred_zero_a1;
  reg  [2:0]                             ls1_scatter_gather_ln_num_a1_q;
  reg  [7:0]                             ls1_scatter_gather_parsed_pred_a1;
  reg                                    ls1_scatter_gather_v_a1_q;
  reg                                    ls1_scatter_gather_v_a2_q;
  wire                                   ls1_spe_part_pg_non_qrep;
  wire                                   ls1_spe_part_pg_rep_qrep;
  wire                                   ls1_spe_part_pg_uop;
  wire                                   ls1_spe_part_pg_uop_qrep;
  wire                                   ls1_spe_zero_pg_non_qrep;
  wire                                   ls1_spe_zero_pg_rep_qrep;
  wire                                   ls1_spe_zero_pg_uop;
  wire [5:0]                             ls1_split_adjusted_access_size_a1;
  reg  [4:0]                             ls1_srca_hash_a1_raw;
  wire [4:0]                             ls1_srca_hash_final_a1;
  reg  [4:0]                             ls1_srcb_hash_a1_raw;
  reg  [31:0]                            ls1_srcpg_data_a1_q;
  wire [31:0]                            ls1_srcpg_data_i2;
  wire [31:0]                            ls1_srcpg_data_pq_a1;
  wire                                   ls1_st_page_split1_a2;
  wire                                   ls1_st_pf_on_rst_full_i2;
  wire                                   ls1_st_pf_on_rst_full_poss_i2;
  wire                                   ls1_thumb_instr_i2;
  wire                                   ls1_uop_cross_32_byte_a1;
  wire [1:0]                             ls1_uop_num_a1;
  wire                                   ls1_uop_older_than_ls0_i2;
  wire                                   ls1_uop_size_16byte_a1;
  wire                                   ls1_uop_size_32byte_a1;
  wire                                   ls1_valid_multi_reg_ld_st_op_a1;
  wire                                   ls1_vl16_a1;
  wire                                   ls2_32byte_ld_st_cache_line_split_2nd_half_a1;
  reg                                    ls2_a1_reject_a1_q;
  wire                                   ls2_a1_reject_i2;
  wire [1:0]                             ls2_bk_pg_1_0;
  wire [1:0]                             ls2_bk_pg_2_1;
  wire [1:0]                             ls2_bk_pg_3_2;
  wire [1:0]                             ls2_bk_pg_4_1;
  wire [1:0]                             ls2_bk_pg_4_3;
  wire [5:3]                             ls2_bnk_dec_needed_cin_0_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_1_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_2_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_3_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_4_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_5_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_6_a1;
  wire [5:3]                             ls2_bnk_dec_needed_cin_7_a1;
  wire                                   ls2_cache_split1_val_a1;
  reg                                    ls2_cache_split2_a1_q;
  wire                                   ls2_ccpass_st_mod_a1;
  wire                                   ls2_cin_0_a1;
  reg  [4:0]                             ls2_cin_hash_a1_raw;
  wire [3:0]                             ls2_compact_pred_el_ln_size_b_d_a1;
  wire [15:0]                            ls2_compact_pred_el_ln_size_b_h_a1;
  wire [7:0]                             ls2_compact_pred_el_ln_size_b_w_a1;
  wire [7:0]                             ls2_compact_pred_el_ln_size_h_d_a1;
  wire [15:0]                            ls2_compact_pred_el_ln_size_h_w_a1;
  wire [15:0]                            ls2_compact_pred_el_ln_size_w_d_a1;
  wire [31:0]                            ls2_cont_parsed_pred_a1;
  wire [5:0]                             ls2_cout_a1;
  wire                                   ls2_el_ln_size_b_d_a1;
  wire                                   ls2_el_ln_size_b_h_a1;
  wire                                   ls2_el_ln_size_b_w_a1;
  wire                                   ls2_el_ln_size_eq_a1;
  wire                                   ls2_el_ln_size_h_d_a1;
  wire                                   ls2_el_ln_size_h_w_a1;
  wire                                   ls2_el_ln_size_w_d_a1;
  wire [11:0]                            ls2_fast_va_a1;
  wire [5:0]                             ls2_g_a1;
  wire                                   ls2_hi_pred_zero_a1;
  wire                                   ls2_ld2_st2_a1;
  wire [31:0]                            ls2_ld2_st2_parsed_pred_a1_uop0;
  wire [31:0]                            ls2_ld2_st2_parsed_pred_a1_uop1;
  wire [15:0]                            ls2_ld2_st2_parsed_pred_a1_uop1_vl16;
  wire                                   ls2_ld3_st3_a1;
  wire [31:0]                            ls2_ld3_st3_parsed_pred_a1_uop0;
  wire [31:0]                            ls2_ld3_st3_parsed_pred_a1_uop1;
  wire [15:0]                            ls2_ld3_st3_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls2_ld3_st3_parsed_pred_a1_uop2;
  wire [15:0]                            ls2_ld3_st3_parsed_pred_a1_uop2_vl16;
  wire                                   ls2_ld4_st4_a1;
  wire [31:0]                            ls2_ld4_st4_parsed_pred_a1_uop0;
  wire [31:0]                            ls2_ld4_st4_parsed_pred_a1_uop1;
  wire [15:0]                            ls2_ld4_st4_parsed_pred_a1_uop1_vl16;
  wire [31:0]                            ls2_ld4_st4_parsed_pred_a1_uop2;
  wire [15:0]                            ls2_ld4_st4_parsed_pred_a1_uop2_vl16;
  wire [31:0]                            ls2_ld4_st4_parsed_pred_a1_uop3;
  wire [15:0]                            ls2_ld4_st4_parsed_pred_a1_uop3_vl16;
  wire                                   ls2_ld_cross_16_32_byte_a1;
  wire                                   ls2_ld_reject_gather_nxt_i2;
  reg  [31:0]                            ls2_ld_st_multi_reg_parsed_pred_a1;
  wire                                   ls2_ld_unpred_sve_uop_i2;
  wire                                   ls2_ldpx_type_i2;
  reg  [1:0]                             ls2_ln_size_a1_q;
  wire                                   ls2_lo_pred_zero_a1;
  wire                                   ls2_lpt_cam_pc_index_clk_en_i2_d4;
  wire [13:0]                            ls2_lpt_cam_pc_index_i2;
  wire [1:0]                             ls2_multi_reg_ld_st_op_a1;
  wire                                   ls2_non_sized_a1;
  wire [5:0]                             ls2_p_a1;
  wire                                   ls2_page_split1_a1;
  wire                                   ls2_page_split1_early_val_a1;
  wire [31:0]                            ls2_parsed_pred_adjusted_a1;
  wire [31:0]                            ls2_parsed_pred_adjusted_masked_a1;
  wire [31:0]                            ls2_parsed_pred_split_adjusted_a1;
  wire [31:0]                            ls2_parsed_pred_split_adjusted_masked_a1;
  wire                                   ls2_pc_index_clken_a1;
  wire                                   ls2_pf_trainable_type_a1;
  wire                                   ls2_precommit_uop_i2;
  wire                                   ls2_precommit_uop_i2_unqual;
  wire                                   ls2_precommit_uop_reject;
  wire                                   ls2_precommit_uop_reject_cnt_clr;
  reg  [15:0]                            ls2_pred_mask;
  wire                                   ls2_qrep_ld_a1;
  wire                                   ls2_rep_ld_a1;
  reg                                    ls2_rep_ld_a2_q;
  wire                                   ls2_rep_pred_zero_a1;
  reg  [2:0]                             ls2_scatter_gather_ln_num_a1_q;
  reg  [7:0]                             ls2_scatter_gather_parsed_pred_a1;
  reg                                    ls2_scatter_gather_v_a1_q;
  reg                                    ls2_scatter_gather_v_a2_q;
  wire                                   ls2_spe_part_pg_non_qrep;
  wire                                   ls2_spe_part_pg_rep_qrep;
  wire                                   ls2_spe_part_pg_uop;
  wire                                   ls2_spe_part_pg_uop_qrep;
  wire                                   ls2_spe_zero_pg_non_qrep;
  wire                                   ls2_spe_zero_pg_rep_qrep;
  wire                                   ls2_spe_zero_pg_uop;
  wire [5:0]                             ls2_split_adjusted_access_size_a1;
  reg  [4:0]                             ls2_srca_hash_a1_raw;
  wire [4:0]                             ls2_srca_hash_final_a1;
  reg  [4:0]                             ls2_srcb_hash_a1_raw;
  reg  [31:0]                            ls2_srcpg_data_a1_q;
  wire [31:0]                            ls2_srcpg_data_i2;
  wire [31:0]                            ls2_srcpg_data_pq_a1;
  wire                                   ls2_st_page_split1_a2;
  wire                                   ls2_st_pf_on_rst_full_i2;
  wire                                   ls2_st_pf_on_rst_full_poss_i2;
  wire                                   ls2_thumb_instr_i2;
  wire                                   ls2_uop_cross_32_byte_a1;
  wire [1:0]                             ls2_uop_num_a1;
  wire                                   ls2_uop_older_than_ls0_i2;
  wire                                   ls2_uop_older_than_ls1_i2;
  wire                                   ls2_uop_size_16byte_a1;
  wire                                   ls2_uop_size_32byte_a1;
  wire                                   ls2_valid_multi_reg_ld_st_op_a1;
  wire                                   ls2_vl16_a1;
  wire                                   ls_ctl_format_ls0_i2;
  wire                                   ls_ctl_format_ls1_i2;
  wire                                   ls_ctl_format_ls2_i2;
  reg                                    ls_enable_serialize_gather_q;
  wire                                   ls_is_uop_reject_unalign_ls0_i2;
  wire                                   ls_is_uop_reject_unalign_ls1_i2;
  wire                                   ls_is_uop_reject_unalign_ls2_i2;
  wire [1:0]                             lsx_precommit_uop_reject_cnt_din;
  wire                                   lsx_precommit_uop_reject_cnt_en;
  reg  [1:0]                             lsx_precommit_uop_reject_cnt_q;
  wire                                   lsx_srcpg_clk_en;
  reg                                    mid_first_lane_page_split_ls0_a3_q;
  reg                                    mid_first_lane_page_split_ls1_a3_q;
  reg                                    mid_first_lane_page_split_ls2_a3_q;
  wire                                   more_than_one_active_lane_pre_ls0_a1;
  reg                                    more_than_one_active_lane_pre_ls0_a2_q;
  wire                                   more_than_one_active_lane_pre_ls1_a1;
  reg                                    more_than_one_active_lane_pre_ls1_a2_q;
  wire                                   more_than_one_active_lane_pre_ls2_a1;
  reg                                    more_than_one_active_lane_pre_ls2_a2_q;
  wire                                   nf_ld_ls0_a1;
  reg                                    nf_ld_ls0_a2_q;
  wire                                   nf_ld_ls1_a1;
  reg                                    nf_ld_ls1_a2_q;
  wire                                   nf_ld_ls2_a1;
  reg                                    nf_ld_ls2_a2_q;
  wire                                   not_nf_or_ff_cont_ld_ls1_a1;
  wire                                   not_nf_or_ff_cont_ld_ls1_a2;
  wire                                   not_nf_or_ff_cont_ld_ls2_a1;
  wire                                   not_nf_or_ff_cont_ld_ls2_a2;
  wire                                   op_val_ls0_a1;
  wire                                   op_val_ls1_a1;
  wire                                   op_val_ls2_a1;
  wire                                   page_split1_more_than_one_active_lane_ls0_a2;
  wire                                   page_split1_more_than_one_active_lane_ls1_a2;
  wire                                   page_split1_more_than_one_active_lane_ls2_a2;
  reg  [31:0]                            page_split_lane_mask_ls0_a2;
  reg  [31:0]                            page_split_lane_mask_ls1_a2;
  reg  [31:0]                            page_split_lane_mask_ls2_a2;
  wire                                   page_split_ls0_a1;
  wire                                   page_split_ls0_a1_a2;
  wire                                   page_split_ls1_a1;
  wire                                   page_split_ls1_a1_a2;
  wire                                   page_split_ls2_a1;
  wire                                   page_split_ls2_a1_a2;
  wire                                   pf_tlb_lookup_drop;
  reg  [3:0]                             pf_tlb_lookup_id_skid_q;
  wire                                   pf_tlb_lookup_injected_a1;
  wire                                   pf_tlb_lookup_injected_i2;
  reg  [3:0]                             pf_tlb_lookup_injected_id_a1_q;
  wire [3:0]                             pf_tlb_lookup_injected_id_outstanding_in;
  reg  [3:0]                             pf_tlb_lookup_injected_id_outstanding_q;
  wire                                   pf_tlb_lookup_outstanding_en;
  wire                                   pf_tlb_lookup_req_skid_in;
  reg                                    pf_tlb_lookup_req_skid_q;
  reg  [48:12]                           pf_tlb_lookup_va_skid_q;
  wire                                   pf_tlb_skid_en;
  wire                                   possible_req_cnt_incr;
  wire                                   precommit_reject_saturated;
  wire                                   precommit_uid_advance_in;
  wire                                   pref_byp_injection_req_made;
  wire                                   pref_injection_req;
  wire                                   pref_injection_req_made;
  wire                                   pref_injection_req_qual;
  wire                                   pref_req_suppress_m0;
  wire                                   pref_req_waiting_cnt_clear;
  wire                                   pref_req_waiting_cnt_en;
  wire [3:0]                             pref_req_waiting_cnt_in;
  wire                                   pref_req_waiting_cnt_incr;
  reg  [3:0]                             pref_req_waiting_cnt_q;
  wire                                   pref_req_waiting_cnt_saturated;
  wire                                   pref_req_waiting_cnt_saturated_nxt;
  wire                                   pref_skid_injection_req;
  wire                                   pref_skid_injection_req_made;
  wire                                   pref_skid_injection_req_qual;
  wire                                   prevent_unalign_ls0_a1;
  wire                                   prevent_unalign_ls1_a1;
  wire                                   prevent_unalign_ls2_a1;
  wire                                   raw_ccpass_ls0_a1;
  wire                                   raw_ccpass_ls1_a1;
  wire                                   raw_ccpass_ls2_a1;
  reg  [31:0]                            raw_pred_first_active_lane_dec_ls0_a1;
  reg  [31:0]                            raw_pred_first_active_lane_dec_ls1_a1;
  reg  [31:0]                            raw_pred_first_active_lane_dec_ls2_a1;
  reg  [4:0]                             raw_pred_first_active_lane_ls0_a1;
  reg  [4:0]                             raw_pred_first_active_lane_ls1_a1;
  reg  [4:0]                             raw_pred_first_active_lane_ls2_a1;
  reg                                    raw_pred_first_vld_lane_found_2_ls0_a1;
  reg                                    raw_pred_first_vld_lane_found_2_ls1_a1;
  reg                                    raw_pred_first_vld_lane_found_2_ls2_a1;
  reg                                    raw_pred_first_vld_lane_found_ls0_a1;
  reg                                    raw_pred_first_vld_lane_found_ls1_a1;
  reg                                    raw_pred_first_vld_lane_found_ls2_a1;
  reg  [31:0]                            raw_pred_second_lane_dec_ls0_a1;
  reg  [31:0]                            raw_pred_second_lane_dec_ls1_a1;
  reg  [31:0]                            raw_pred_second_lane_dec_ls2_a1;
  reg  [4:0]                             raw_pred_second_lane_ls0_a1;
  reg  [4:0]                             raw_pred_second_lane_ls0_a2_q;
  reg  [4:0]                             raw_pred_second_lane_ls1_a1;
  reg  [4:0]                             raw_pred_second_lane_ls1_a2_q;
  reg  [4:0]                             raw_pred_second_lane_ls2_a1;
  reg  [4:0]                             raw_pred_second_lane_ls2_a2_q;
  reg                                    raw_pred_second_vld_lane_found_ls0_a1;
  reg                                    raw_pred_second_vld_lane_found_ls1_a1;
  reg                                    raw_pred_second_vld_lane_found_ls2_a1;
  wire                                   ready_to_inject_addr;
  wire [3:0]                             req_waiting_cnt_saturated_bundle;
  wire [3:0]                             req_waiting_cnt_saturated_bundle_masked;
  wire                                   req_waiting_en;
  wire [3:0]                             round_robin_select_in;
  reg  [3:0]                             round_robin_select_q;
  wire [3:0]                             rr_find_first;
  wire [3:0]                             rr_find_first_masked;
  wire [3:0]                             rr_mask;
  wire                                   rst_full_ls0_din;
  reg                                    rst_full_ls0_q;
  wire                                   rst_full_ls1_din;
  reg                                    rst_full_ls1_q;
  wire                                   rst_full_ls2_din;
  reg                                    rst_full_ls2_q;
  wire                                   scatter_gather_cur_lane_eq_first_active_lane_ls0_a1;
  reg                                    scatter_gather_cur_lane_eq_first_active_lane_ls0_a2_q;
  wire                                   scatter_gather_cur_lane_eq_first_active_lane_ls1_a1;
  reg                                    scatter_gather_cur_lane_eq_first_active_lane_ls1_a2_q;
  wire                                   scatter_gather_cur_lane_eq_first_active_lane_ls2_a1;
  reg                                    scatter_gather_cur_lane_eq_first_active_lane_ls2_a2_q;
  wire                                   snp_inject_bubble_req;
  wire                                   spe_inject_outstanding_in;
  reg                                    spe_inject_outstanding_q;
  wire                                   spe_injection_req_qual;
  wire                                   spe_req_suppress_m0;
  wire                                   spe_req_waiting_cnt_clear;
  wire                                   spe_req_waiting_cnt_en;
  wire [3:0]                             spe_req_waiting_cnt_in;
  wire                                   spe_req_waiting_cnt_incr;
  reg  [3:0]                             spe_req_waiting_cnt_q;
  wire                                   spe_req_waiting_cnt_saturated;
  wire                                   spe_req_waiting_cnt_saturated_nxt;
  reg                                    srca_hi_eq_zero_ls0_a1_q;
  wire                                   srca_hi_eq_zero_ls0_i2;
  reg                                    srca_hi_eq_zero_ls1_a1_q;
  wire                                   srca_hi_eq_zero_ls1_i2;
  reg                                    srca_hi_eq_zero_ls2_a1_q;
  wire                                   srca_hi_eq_zero_ls2_i2;
  wire                                   srca_v_ls0_i2;
  wire                                   srca_v_ls1_i2;
  wire                                   srca_v_ls2_i2;
  wire                                   srcb_eq_zero_dup_ls0_a1_q;
  wire                                   srcb_eq_zero_dup_ls1_a1_q;
  wire                                   srcb_eq_zero_dup_ls2_a1_q;
  wire [1:0]                             srcb_eq_zero_ls0_a1;
  reg  [1:0]                             srcb_eq_zero_ls0_a1_q;
  wire [1:0]                             srcb_eq_zero_ls0_i2;
  wire [1:0]                             srcb_eq_zero_ls1_a1;
  reg  [1:0]                             srcb_eq_zero_ls1_a1_q;
  wire [1:0]                             srcb_eq_zero_ls1_i2;
  wire [1:0]                             srcb_eq_zero_ls2_a1;
  reg  [1:0]                             srcb_eq_zero_ls2_a1_q;
  wire [1:0]                             srcb_eq_zero_ls2_i2;
  wire                                   srcb_sel_no_ext_ls0_i2;
  wire                                   srcb_sel_no_ext_ls1_i2;
  wire                                   srcb_sel_no_ext_ls2_i2;
  wire                                   srcb_sel_no_shift_ls0_i2;
  wire                                   srcb_sel_no_shift_ls1_i2;
  wire                                   srcb_sel_no_shift_ls2_i2;
  wire                                   srcb_sel_sext_ls0_i2;
  wire                                   srcb_sel_sext_ls1_i2;
  wire                                   srcb_sel_sext_ls2_i2;
  wire                                   srcb_sel_shift1_ls0_i2;
  wire                                   srcb_sel_shift1_ls1_i2;
  wire                                   srcb_sel_shift1_ls2_i2;
  wire                                   srcb_sel_shift2_ls0_i2;
  wire                                   srcb_sel_shift2_ls1_i2;
  wire                                   srcb_sel_shift2_ls2_i2;
  wire                                   srcb_sel_shift3_ls0_i2;
  wire                                   srcb_sel_shift3_ls1_i2;
  wire                                   srcb_sel_shift3_ls2_i2;
  reg  [3:0]                             srcp_data_ls0_a1_q;
  wire                                   srcp_data_ls0_i2_en;
  reg  [3:0]                             srcp_data_ls1_a1_q;
  wire                                   srcp_data_ls1_i2_en;
  reg  [3:0]                             srcp_data_ls2_a1_q;
  wire                                   srcp_data_ls2_i2_en;
  wire                                   srcpg_issue_v_ls0_i2;
  wire                                   srcpg_issue_v_ls1_i2;
  wire                                   srcpg_issue_v_ls2_i2;
  wire                                   st_pf_vld_ls0_i2;
  wire                                   st_pf_vld_ls1_i2;
  wire                                   st_pf_vld_ls2_i2;
  wire                                   tbe_inject_outstanding_in;
  reg                                    tbe_inject_outstanding_q;
  wire                                   tbe_injection_req_qual;
  wire                                   tbe_req_suppress_m0;
  wire                                   tbe_req_waiting_cnt_clear;
  wire                                   tbe_req_waiting_cnt_en;
  wire [3:0]                             tbe_req_waiting_cnt_in;
  wire                                   tbe_req_waiting_cnt_incr;
  reg  [3:0]                             tbe_req_waiting_cnt_q;
  wire                                   tbe_req_waiting_cnt_saturated;
  wire                                   tbe_req_waiting_cnt_saturated_nxt;
  wire                                   three_bank_ld_ls0_a1;
  wire                                   three_bank_ld_ls1_a1;
  wire                                   three_bank_ld_ls2_a1;
  wire                                   tmo_inject_outstanding_in;
  reg                                    tmo_inject_outstanding_q;
  wire                                   tmo_injection_req_qual;
  wire                                   tmo_req_suppress_m0;
  wire                                   tmo_req_waiting_cnt_clear;
  wire                                   tmo_req_waiting_cnt_en;
  wire [3:0]                             tmo_req_waiting_cnt_in;
  wire                                   tmo_req_waiting_cnt_incr;
  reg  [3:0]                             tmo_req_waiting_cnt_q;
  wire                                   tmo_req_waiting_cnt_saturated;
  wire                                   tmo_req_waiting_cnt_saturated_nxt;
  reg  [32:0]                            tmp_ls_uop_ctl_ls0_a1_q;
  reg  [32:0]                            tmp_ls_uop_ctl_ls1_a1_q;
  reg  [32:0]                            tmp_ls_uop_ctl_ls2_a1_q;
  wire                                   toggle_favors_tmo_in;
  reg                                    toggle_favors_tmo_q;
  reg  [5:0]                             total_size_decoded_ls0_a1;
  reg  [5:0]                             total_size_decoded_ls1_a1;
  reg  [5:0]                             total_size_decoded_ls2_a1;
  reg  [31:0]                            total_size_mask_ls0_a1;
  reg  [31:0]                            total_size_mask_ls1_a1;
  reg  [31:0]                            total_size_mask_ls2_a1;
  wire                                   two_bank_ld_ls0_a1;
  wire                                   two_bank_ld_ls1_a1;
  wire                                   two_bank_ld_ls2_a1;
  wire                                   unalign2_arb_ld_ls0_i2;
  wire                                   unalign2_arb_ld_ls1_i2;
  wire                                   unalign2_arb_ld_ls2_i2;
  wire                                   unalign2_dup_ls0_a1_q;
  wire                                   unalign2_dup_ls1_a1_q;
  wire                                   unalign2_dup_ls2_a1_q;
  wire [31:0]                            unalign2_src_b_ls0_i2;
  wire [31:0]                            unalign2_src_b_ls1_i2;
  wire [31:0]                            unalign2_src_b_ls2_i2;
  wire                                   unalign_hw_split_ls0_a1;
  wire                                   unalign_hw_split_ls1_a1;
  wire                                   unalign_hw_split_ls2_a1;
  wire                                   unalign_ls0_a1_a2;
  wire                                   unalign_ls1_a1_a2;
  wire                                   unalign_ls2_a1_a2;
  wire                                   unalign_qw_split_ls0_a1;
  wire                                   unalign_qw_split_ls1_a1;
  wire                                   unalign_qw_split_ls2_a1;
  reg  [3:0]                             unshift_wv_ls0_a1;
  reg  [3:0]                             unshift_wv_ls1_a1;
  reg  [3:0]                             unshift_wv_ls2_a1;
  wire [1:0]                             unused_bytes_ls0_a2;
  wire [1:0]                             unused_bytes_ls1_a2;
  wire [1:0]                             unused_bytes_ls2_a2;
  wire                                   uop_32b_low_end_byte_carry_out_5_ls0_a1;
  wire                                   uop_32b_low_end_byte_carry_out_5_ls1_a1;
  wire                                   uop_32b_low_end_byte_carry_out_5_ls2_a1;
  wire [5:3]                             uop_32b_low_end_byte_ls0_a1;
  wire [5:3]                             uop_32b_low_end_byte_ls1_a1;
  wire [5:3]                             uop_32b_low_end_byte_ls2_a1;
  reg  [4:0]                             uop_size_dec1_raw_ls0_a1_q;
  reg  [4:0]                             uop_size_dec1_raw_ls0_i2;
  reg  [4:0]                             uop_size_dec1_raw_ls1_a1_q;
  reg  [4:0]                             uop_size_dec1_raw_ls1_i2;
  reg  [4:0]                             uop_size_dec1_raw_ls2_a1_q;
  reg  [4:0]                             uop_size_dec1_raw_ls2_i2;
  wire                                   va_v_ld_st_ccpass_ls0_a1;
  wire                                   va_v_ld_st_ccpass_ls1_a1;
  wire                                   va_v_ld_st_ccpass_ls2_a1;
  reg                                    vld_lane_found_ls0_a1;
  reg                                    vld_lane_found_ls1_a1;
  reg                                    vld_lane_found_ls2_a1;
  reg                                    vld_last_lane_found_ls0_a1;
  reg                                    vld_last_lane_found_ls1_a1;
  reg                                    vld_last_lane_found_ls2_a1;
  wire                                   word_aligned_ls0_a1;
  wire                                   word_aligned_ls1_a1;
  wire                                   word_aligned_ls2_a1;
  wire [19:0]                            wv_cl_shift_ls0_a1;
  wire [19:0]                            wv_cl_shift_ls1_a1;
  wire [19:0]                            wv_cl_shift_ls2_a1;
  wire [3:0]                             wv_nxt_cl_ls0_a1;
  reg  [3:0]                             wv_nxt_cl_ls0_a2_q;
  wire [3:0]                             wv_nxt_cl_ls1_a1;
  reg  [3:0]                             wv_nxt_cl_ls1_a2_q;
  wire [3:0]                             wv_nxt_cl_ls2_a1;
  reg  [3:0]                             wv_nxt_cl_ls2_a2_q;
  wire [7:0]                             wv_qw_align_ls0_a1;
  wire [7:0]                             wv_qw_align_ls1_a1;
  wire [7:0]                             wv_qw_align_ls2_a1;
  wire [7:0]                             wv_qw_shift_ls0_a1;
  wire [7:0]                             wv_qw_shift_ls1_a1;
  wire [7:0]                             wv_qw_shift_ls2_a1;
  reg  [15:0]                            wv_unalign_ls0_a1;
  reg  [15:0]                            wv_unalign_ls1_a1;
  reg  [15:0]                            wv_unalign_ls2_a1;


genvar src;




  assign rar_precommit_uid[`RV_BC_UID] = ~rar_entry_supermerged_q ? precommit_uid_q[`RV_BC_UID] : {`RV_BC_UID_SIZE{1'b0}} ; 



  assign ls0_ldpx_type_i2 = (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX) & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE];

  assign ls0_precommit_uop_i2               = issue_v_ls0_i2_q &  (uid_ls0_i2_q[`RV_BC_UID] == precommit_uid_q[`RV_BC_UID]) & 
                                               ~address_inject_val_ls0_i2_q & ~is_ls_issue_cancel_ls0_i2 &
                                               ((rid_ls0_i2_q == is_ls_oldest_ld_rid_ls0) | ~ls0_ldpx_type_i2); 





  assign ls1_ldpx_type_i2 = (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX) & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE];

  assign ls1_precommit_uop_i2_unqual        = issue_v_ls1_i2_q &  (uid_ls1_i2_q[`RV_BC_UID] == precommit_uid_q[`RV_BC_UID]) &
                                               ((rid_ls1_i2_q == is_ls_oldest_ld_rid_ls1) | ~ls1_ldpx_type_i2); 
  assign ls1_precommit_uop_i2               = issue_v_ls1_i2_q &  (uid_ls1_i2_q[`RV_BC_UID] == precommit_uid_q[`RV_BC_UID]) & 
                                               ~address_inject_val_ls1_i2_q & ~is_ls_issue_cancel_ls1_i2 &
                                               ((rid_ls1_i2_q == is_ls_oldest_ld_rid_ls1) | ~ls1_ldpx_type_i2); 
  assign ls1_precommit_uop_reject           = ls1_precommit_uop_i2   &  ls_is_uop_reject_unalign_ls1_i2
                                              | ls1_precommit_uop_a1_q &  reject_unalign_ls1_a1;
  assign ls1_precommit_uop_reject_cnt_clr   = ls1_precommit_uop_a1_q & ~reject_unalign_ls1_a1 & ~unalign2_ls1_a1_q
                                              & (issue_ld_val_ls1_a1_q | issue_st_val_ls1_a1_q);



  assign ls2_ldpx_type_i2 = (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX) & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE];

  assign ls2_precommit_uop_i2_unqual        = issue_v_ls2_i2_q &  (uid_ls2_i2_q[`RV_BC_UID] == precommit_uid_q[`RV_BC_UID]) &
                                               ((rid_ls2_i2_q == is_ls_oldest_ld_rid_ls2) | ~ls2_ldpx_type_i2); 
  assign ls2_precommit_uop_i2               = issue_v_ls2_i2_q &  (uid_ls2_i2_q[`RV_BC_UID] == precommit_uid_q[`RV_BC_UID]) & 
                                               ~address_inject_val_ls2_i2_q & ~is_ls_issue_cancel_ls2_i2 &
                                               ((rid_ls2_i2_q == is_ls_oldest_ld_rid_ls2) | ~ls2_ldpx_type_i2); 
  assign ls2_precommit_uop_reject           = ls2_precommit_uop_i2   &  ls_is_uop_reject_unalign_ls2_i2
                                              | ls2_precommit_uop_a1_q &  reject_unalign_ls2_a1;
  assign ls2_precommit_uop_reject_cnt_clr   = ls2_precommit_uop_a1_q & ~reject_unalign_ls2_a1 & ~unalign2_ls2_a1_q
                                              & (issue_ld_val_ls2_a1_q | issue_st_val_ls2_a1_q);




   rv_bc_ls_age_compare u_age_compare_ls1_vs_ls0_i2 (
      .uid_a(uid_ls0_i2_q[`RV_BC_UID]),
      .uid_b(uid_ls1_i2_q[`RV_BC_UID]),
      .a_older_than_b(ls0_uop_older_than_ls1_i2)
   );

  assign ls1_uop_older_than_ls0_i2 = ~ls0_uop_older_than_ls1_i2;

   rv_bc_ls_age_compare u_age_compare_ls2_vs_ls0_i2 (
      .uid_a(uid_ls0_i2_q[`RV_BC_UID]),
      .uid_b(uid_ls2_i2_q[`RV_BC_UID]),
      .a_older_than_b(ls0_uop_older_than_ls2_i2)
   );

   rv_bc_ls_age_compare u_age_compare_ls1_vs_ls2_i2 (
      .uid_a(uid_ls1_i2_q[`RV_BC_UID]),
      .uid_b(uid_ls2_i2_q[`RV_BC_UID]),
      .a_older_than_b(ls1_uop_older_than_ls2_i2)
   );

  assign ls2_uop_older_than_ls0_i2 = ~ls0_uop_older_than_ls2_i2;
  assign ls2_uop_older_than_ls1_i2 = ~ls1_uop_older_than_ls2_i2;

  assign precommit_reject_saturated =    (lsx_precommit_uop_reject_cnt_q[1:0] == 2'b11);
  assign lsx_srcpg_clk_en =   (issue_v_early_ls0_i2   & ~address_inject_val_ls0_i2_q | ls0_srcpg_v_a1_q   | ls0_srcpg_v_a2_q)
                            | (issue_v_early_ls1_i2 & ~address_inject_val_ls1_i2_q | ls1_srcpg_v_a1_q | ls1_srcpg_v_a2_q)
                            | (issue_v_early_ls2_i2 & ~address_inject_val_ls2_i2_q | ls2_srcpg_v_a1_q | ls2_srcpg_v_a2_q)
                            ;

assign any_issue_v_i2 = issue_v_ls0_i2_q & ~is_ls_issue_cancel_ls0_i2 & ~ls0_uop_flush_i2 & ~address_inject_val_ls0_i2_q
                      | issue_v_ls1_i2_q & ~is_ls_issue_cancel_ls1_i2 & ~ls1_uop_flush_i2 & ~address_inject_val_ls1_i2_q
                      | issue_v_ls2_i2_q & ~is_ls_issue_cancel_ls2_i2 & ~ls2_uop_flush_i2 & ~address_inject_val_ls2_i2_q
                       ;


  assign issue_v_ls0_i1 = is_ls_issue_v_ls0_i1   & ~is_ls_issue_cancel_ls0_i1;

  rv_bc_flush_compare   u_ls0_uop_flush_i2 (
      .flush_match (ls0_uop_flush_i2),
      .flush       (flush),
      .flush_uid   (flush_uid[`RV_BC_UID]), 
      .uop_uid     (uid_ls0_i2_q[`RV_BC_UID]) 
    );




assign issue_v_ls0_i2 =       issue_v_ls0_i2_q & ~is_ls_issue_cancel_ls0_i2
                                             & (~ls0_uop_flush_i2 | address_inject_val_ls0_i2_q)
                                             & ~unalign2_ls0_i2                  
                                             & (~dep_d4_resx_ls0_i2_q | ~ls_is_resx_cancel_d4 | address_inject_val_ls0_i2_q)
                                             & (~dep_d4_resy_ls0_i2_q | ~ls_is_resy_cancel_d4 | address_inject_val_ls0_i2_q)
                                             & (~dep_d4_resz_ls0_i2_q | ~ls_is_resz_cancel_d4 | address_inject_val_ls0_i2_q);

assign issue_v_early_ls0_i2 =       issue_v_ls0_i2_q & ~is_ls_issue_cancel_ls0_i2
                                             &  ~unalign2_ls0_i2 ;           

assign issue_v_poss_ls0_i2  =       issue_v_ls0_i2_q
                                             &  ~unalign2_ls0_i2 ;

assign issue_cancel_ls0_i2  = ~address_inject_val_ls0_i2_q
                              & ( is_ls_issue_cancel_ls0_i2
                                | dep_d4_resx_ls0_i2_q & ls_is_resx_cancel_d4
                                | dep_d4_resy_ls0_i2_q & ls_is_resy_cancel_d4
                                | dep_d4_resz_ls0_i2_q & ls_is_resz_cancel_d4);

  assign op_val_ls0_a1 = (ld_val_ls0_a1 | st_val_ls0_a1) & ~unalign2_ls0_a1_q;
 
  assign ld_val_ls0_clken_a1 = ld_val_ls0_a1 & ~unalign2_ls0_a1_q;

  assign address_inject_val_ls0_i1 = is_ls_issue_v_ls0_i1 & is_ls_issue_type_ls0_i1 ;
  
  assign tmo_inject_val_ls0_i2 = address_inject_val_ls0_i2_q &  tmo_inject_outstanding_q;
  assign spe_inject_val_ls0_i2 = address_inject_val_ls0_i2_q &  spe_inject_outstanding_q;

  assign tbe_inject_val_ls0_i2 = address_inject_val_ls0_i2_q &  tbe_inject_outstanding_q;

  assign ls0_type_ldg_i2 = (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG);




  assign ld_val_ls0_arb_possible_i2 = (issue_ld_val_ls0_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ~(ls_enable_serialize_gather_q & iq0_gather_ld_i2) & ~ls0_ld_ssbb_blk_i2) | 
                                        (issue_ld_val_ls0_a1_q & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & unalign2_ls0_i2 & ~(ls_enable_serialize_gather_q & iq0_gather_ld_a1_q) & ~ls0_ld_ssbb_blk_a1_q) | 
                                        ( issue_v_ls0_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls0_i2 & rst_full_ls0_q ) ;

  assign ls0_st_pf_on_rst_full_i2 = ( issue_v_ls0_i2 & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls0_i2 & rst_full_ls0_q ) ;
  assign ls0_st_pf_on_rst_full_poss_i2 = ( issue_v_ls0_i2_q & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls0_i2 & rst_full_ls0_q ) ;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_v_ls0_i2_q
    if (reset_i == 1'b1)
      issue_v_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0)
      issue_v_ls0_i2_q <= `RV_BC_DFF_DELAY issue_v_ls0_i1;
    else
      issue_v_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else
      issue_v_ls0_i2_q <= `RV_BC_DFF_DELAY issue_v_ls0_i1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_st_pf_on_rst_full_a1_q
    if (reset_i == 1'b1)
      ls0_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls0_st_pf_on_rst_full_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls0_st_pf_on_rst_full_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ld_val_ls0_a1_q
    if (reset_i == 1'b1)
      issue_ld_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      issue_ld_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls0_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ld_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      issue_ld_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls0_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls0_arb_possible_a1_q
    if (reset_i == 1'b1)
      ld_val_ls0_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ld_val_ls0_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls0_arb_possible_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls0_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ld_val_ls0_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls0_arb_possible_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_st_val_ls0_a1_q
    if (reset_i == 1'b1)
      issue_st_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      issue_st_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls0_a1_din;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      issue_st_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      issue_st_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls0_a1_din;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls0_a2_q
    if (reset_i == 1'b1)
      ld_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ld_val_ls0_a2_q <= `RV_BC_DFF_DELAY ld_val_ls0_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ld_val_ls0_a2_q <= `RV_BC_DFF_DELAY ld_val_ls0_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_st_val_ls0_a2_q
    if (reset_i == 1'b1)
      st_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      st_val_ls0_a2_q <= `RV_BC_DFF_DELAY st_val_ls0_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      st_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      st_val_ls0_a2_q <= `RV_BC_DFF_DELAY st_val_ls0_a1;
`endif
  end



  always_ff @(posedge clk_agu0)
  begin: u_ls0_frc_unchecked_a1_q
    if (issue_v_poss_ls0_i2 == 1'b1)
      ls0_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY is_ls_force_unchecked_ls0_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu0)
  begin: u_iq0_gather_ld_a1_q
    if (issue_v_poss_ls0_i2 == 1'b1)
      iq0_gather_ld_a1_q <= `RV_BC_DFF_DELAY iq0_gather_ld_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      iq0_gather_ld_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_iq0_gather_ld_a2_q
    if (any_issue_v_ls0_i2_a2 == 1'b1)
      iq0_gather_ld_a2_q <= `RV_BC_DFF_DELAY iq0_gather_ld_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      iq0_gather_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ls0_element_size_a1[2:0] = ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_E_SIZE];

   assign ls0_vl16_a1 = 1'b1;


  assign ls0_ld_unpred_sve_uop_i2 = issue_ld_val_ls0_i2 & ~address_inject_val_ls0_i2_q & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_UNPRED_LD);


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_ls0_ld_unpred_sve_uop_a1_q
    if (reset_i == 1'b1)
      ls0_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls0_i2 == 1'b1)
      ls0_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls0_ld_unpred_sve_uop_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls0_i2 == 1'b1)
      ls0_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls0_ld_unpred_sve_uop_i2;
`endif
  end


  assign iq0_gather_ld_i2 = ((ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) 
                            |  (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)) & ~address_inject_val_ls0_i2_q;

  assign is_ls_srcpg_v_ls0_qual_i2 = unalign2_ls0_i2 ? ls0_srcpg_v_a1_q : is_ls_srcpg_v_ls0_i2 & issue_v_early_ls0_i2;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_srcpg_v_a1_q
    if (reset_i == 1'b1)
      ls0_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls0_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls0_qual_i2;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls0_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls0_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls0_qual_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_srcpg_v_a2_q
    if (reset_i == 1'b1)
      ls0_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls0_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls0_srcpg_v_a1_q;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls0_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls0_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls0_srcpg_v_a1_q;
`endif
  end


  assign ls0_srcpg_data_i2[31:0] = {16'h0000, is_ls_srcpg_data_ls0_i2[15:0]};

  assign srcpg_issue_v_ls0_i2 = issue_v_poss_ls0_i2 & is_ls_srcpg_v_ls0_i2;
  

  always_ff @(posedge clk_agu0)
  begin: u_ls0_srcpg_data_a1_q_31_0
    if (srcpg_issue_v_ls0_i2 == 1'b1)
      ls0_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY ls0_srcpg_data_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (srcpg_issue_v_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  assign ls0_scatter_gather_v_i2 = issue_v_ls0_i2_q & ( (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)) |
                                                           (~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ( (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) | 
                                                                                                           (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD) |
                                                          (((ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD) | 
                                                           ((ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLI_MASK) == `RV_BC_LS_TYPE_PLI)) & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_RES_EXT] 
                                                                                                         ) 
                                                                                                            
                                                            )
                                                          ); 

  assign is_ls_dsty_vlreg_ls0_i2[1:0] =  {is_ls_dsty_vlreg_ls0_i2_q[1] | ls0_scatter_gather_v_i2, is_ls_dsty_vlreg_ls0_i2_q[0]} ;

  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_ls0_ln_size_a1_q_1_0
    if (reset_i == 1'b1)
      ls0_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls0_i2 == 1'b1)
      ls0_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls0_i2[1:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`else
    else if (srcpg_issue_v_ls0_i2 == 1'b1)
      ls0_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls0_i2[1:0];
`endif
  end


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_ls0_scatter_gather_ln_num_a1_q_2_0
    if (reset_i == 1'b1)
      ls0_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls0_i2 == 1'b1)
      ls0_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls0_i2_q[2:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'bx}};
`else
    else if (srcpg_issue_v_ls0_i2 == 1'b1)
      ls0_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls0_i2_q[2:0];
`endif
  end




  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_ls0_scatter_gather_v_a1_q
    if (reset_i == 1'b1)
      ls0_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls0_i2 == 1'b1)
      ls0_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls0_scatter_gather_v_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls0_i2 == 1'b1)
      ls0_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls0_scatter_gather_v_i2;
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls0_scatter_gather_v_a2_q
    if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY ls0_scatter_gather_v_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end







  always_comb 
  begin: u_ls0_srcpg_data_a1_31_0
    case(ls0_ln_size_a1_q[1:0])
      2'b00: ls0_srcpg_data_a1[31:0] = ls0_srcpg_data_a1_q[31:0];  
      2'b01: ls0_srcpg_data_a1[31:0] = {{2{ls0_srcpg_data_a1_q[30]}}, {2{ls0_srcpg_data_a1_q[28]}}, {2{ls0_srcpg_data_a1_q[26]}}, {2{ls0_srcpg_data_a1_q[24]}}, {2{ls0_srcpg_data_a1_q[22]}}, {2{ls0_srcpg_data_a1_q[20]}}, {2{ls0_srcpg_data_a1_q[18]}}, {2{ls0_srcpg_data_a1_q[16]}}, {2{ls0_srcpg_data_a1_q[14]}}, {2{ls0_srcpg_data_a1_q[12]}}, {2{ls0_srcpg_data_a1_q[10]}}, {2{ls0_srcpg_data_a1_q[8]}}, {2{ls0_srcpg_data_a1_q[6]}}, {2{ls0_srcpg_data_a1_q[4]}}, {2{ls0_srcpg_data_a1_q[2]}}, {2{ls0_srcpg_data_a1_q[0]}}};  
      2'b10: ls0_srcpg_data_a1[31:0] = {{4{ls0_srcpg_data_a1_q[28]}}, {4{ls0_srcpg_data_a1_q[24]}}, {4{ls0_srcpg_data_a1_q[20]}}, {4{ls0_srcpg_data_a1_q[16]}}, {4{ls0_srcpg_data_a1_q[12]}}, {4{ls0_srcpg_data_a1_q[8]}}, {4{ls0_srcpg_data_a1_q[4]}}, {4{ls0_srcpg_data_a1_q[0]}}};  
      2'b11: ls0_srcpg_data_a1[31:0] = {{8{ls0_srcpg_data_a1_q[24]}}, {8{ls0_srcpg_data_a1_q[16]}}, {8{ls0_srcpg_data_a1_q[8]}}, {8{ls0_srcpg_data_a1_q[0]}}};  
      default: ls0_srcpg_data_a1[31:0] = {32{1'bx}};
    endcase
  end




   assign ls0_el_ln_size_b_h_a1 = (ls0_ln_size_a1_q[1:0] == 2'b01) & (ls0_element_size_a1[1:0] == 2'b00) ;
   assign ls0_el_ln_size_b_w_a1 = (ls0_ln_size_a1_q[1:0] == 2'b10) & (ls0_element_size_a1[1:0] == 2'b00) ;
   assign ls0_el_ln_size_b_d_a1 = (ls0_ln_size_a1_q[1:0] == 2'b11) & (ls0_element_size_a1[1:0] == 2'b00) ;
   assign ls0_el_ln_size_h_w_a1 = (ls0_ln_size_a1_q[1:0] == 2'b10) & (ls0_element_size_a1[1:0] == 2'b01) ;
   assign ls0_el_ln_size_h_d_a1 = (ls0_ln_size_a1_q[1:0] == 2'b11) & (ls0_element_size_a1[1:0] == 2'b01) ;
   assign ls0_el_ln_size_w_d_a1 = (ls0_ln_size_a1_q[1:0] == 2'b11) & (ls0_element_size_a1[1:0] == 2'b10) ;
   assign ls0_el_ln_size_eq_a1  = (ls0_ln_size_a1_q[1:0] == ls0_element_size_a1[1:0]) ;


   assign ls0_compact_pred_el_ln_size_b_h_a1[15:0] = {ls0_srcpg_data_a1_q[30], ls0_srcpg_data_a1_q[28], ls0_srcpg_data_a1_q[26], ls0_srcpg_data_a1_q[24], 
                                                  ls0_srcpg_data_a1_q[22], ls0_srcpg_data_a1_q[20], ls0_srcpg_data_a1_q[18], ls0_srcpg_data_a1_q[16],
                                                  ls0_srcpg_data_a1_q[14], ls0_srcpg_data_a1_q[12], ls0_srcpg_data_a1_q[10], ls0_srcpg_data_a1_q[ 8],
                                                  ls0_srcpg_data_a1_q[ 6], ls0_srcpg_data_a1_q[ 4], ls0_srcpg_data_a1_q[ 2], ls0_srcpg_data_a1_q[ 0]}; 

   assign ls0_compact_pred_el_ln_size_b_w_a1[7:0] =  {ls0_srcpg_data_a1_q[28], ls0_srcpg_data_a1_q[24],        
                                                  ls0_srcpg_data_a1_q[20], ls0_srcpg_data_a1_q[16],
                                                  ls0_srcpg_data_a1_q[12], ls0_srcpg_data_a1_q[ 8],
                                                  ls0_srcpg_data_a1_q[ 4], ls0_srcpg_data_a1_q[ 0]};

   assign ls0_compact_pred_el_ln_size_b_d_a1[3:0] =  {ls0_srcpg_data_a1_q[24],
                                                  ls0_srcpg_data_a1_q[16],
                                                  ls0_srcpg_data_a1_q[ 8],
                                                  ls0_srcpg_data_a1_q[ 0]};


   assign ls0_compact_pred_el_ln_size_h_w_a1[15:0] =  {{2{ls0_srcpg_data_a1_q[28]}}, {2{ls0_srcpg_data_a1_q[24]}},        
                                                   {2{ls0_srcpg_data_a1_q[20]}}, {2{ls0_srcpg_data_a1_q[16]}},
                                                   {2{ls0_srcpg_data_a1_q[12]}}, {2{ls0_srcpg_data_a1_q[ 8]}},
                                                   {2{ls0_srcpg_data_a1_q[ 4]}}, {2{ls0_srcpg_data_a1_q[ 0]}}};

   assign ls0_compact_pred_el_ln_size_h_d_a1[7:0] =  {{2{ls0_srcpg_data_a1_q[24]}},
                                                  {2{ls0_srcpg_data_a1_q[16]}},
                                                  {2{ls0_srcpg_data_a1_q[ 8]}},
                                                  {2{ls0_srcpg_data_a1_q[ 0]}}};

   assign ls0_compact_pred_el_ln_size_w_d_a1[15:0] =  {{4{ls0_srcpg_data_a1_q[24]}},
                                                         {4{ls0_srcpg_data_a1_q[16]}},
                                                         {4{ls0_srcpg_data_a1_q[ 8]}},
                                                         {4{ls0_srcpg_data_a1_q[ 0]}}};

 
   assign ls0_ld2_st2_a1 = (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2);
   assign ls0_ld3_st3_a1 = (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3);
   assign ls0_ld4_st4_a1 = (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4);

   assign ls0_uop_num_a1[1:0] = {2{ls0_valid_multi_reg_ld_st_op_a1}} & ls0_scatter_gather_ln_num_a1_q[1:0];  


   assign ls0_ld2_st2_parsed_pred_a1_uop0[31:0] =   {{2{ls0_srcpg_data_a1[15]}}, {2{ls0_srcpg_data_a1[14]}}, {2{ls0_srcpg_data_a1[13]}}, {2{ls0_srcpg_data_a1[12]}}, 
                                                       {2{ls0_srcpg_data_a1[11]}}, {2{ls0_srcpg_data_a1[10]}}, {2{ls0_srcpg_data_a1[ 9]}}, {2{ls0_srcpg_data_a1[ 8]}},
                                                       {2{ls0_srcpg_data_a1[ 7]}}, {2{ls0_srcpg_data_a1[ 6]}}, {2{ls0_srcpg_data_a1[ 5]}}, {2{ls0_srcpg_data_a1[ 4]}},
                                                       {2{ls0_srcpg_data_a1[ 3]}}, {2{ls0_srcpg_data_a1[ 2]}}, {2{ls0_srcpg_data_a1[ 1]}}, {2{ls0_srcpg_data_a1[ 0]}}}; 

   assign ls0_ld2_st2_parsed_pred_a1_uop1[31:0] =   {{2{ls0_srcpg_data_a1[31]}}, {2{ls0_srcpg_data_a1[30]}}, {2{ls0_srcpg_data_a1[29]}}, {2{ls0_srcpg_data_a1[28]}}, 
                                                       {2{ls0_srcpg_data_a1[27]}}, {2{ls0_srcpg_data_a1[26]}}, {2{ls0_srcpg_data_a1[25]}}, {2{ls0_srcpg_data_a1[24]}},
                                                       {2{ls0_srcpg_data_a1[23]}}, {2{ls0_srcpg_data_a1[22]}}, {2{ls0_srcpg_data_a1[21]}}, {2{ls0_srcpg_data_a1[20]}},
                                                       {2{ls0_srcpg_data_a1[19]}}, {2{ls0_srcpg_data_a1[18]}}, {2{ls0_srcpg_data_a1[17]}}, {2{ls0_srcpg_data_a1[16]}}};

 
   assign ls0_ld3_st3_parsed_pred_a1_uop0[31:0] =   {{2{ls0_srcpg_data_a1[10]}}, {3{ls0_srcpg_data_a1[ 9]}}, {3{ls0_srcpg_data_a1[ 8]}},
                                                       {3{ls0_srcpg_data_a1[ 7]}}, {3{ls0_srcpg_data_a1[ 6]}}, {3{ls0_srcpg_data_a1[ 5]}}, {3{ls0_srcpg_data_a1[ 4]}},
                                                       {3{ls0_srcpg_data_a1[ 3]}}, {3{ls0_srcpg_data_a1[ 2]}}, {3{ls0_srcpg_data_a1[ 1]}}, {3{ls0_srcpg_data_a1[ 0]}}}; 

   assign ls0_ld3_st3_parsed_pred_a1_uop1[31:0] =    {{{ls0_srcpg_data_a1[21]}},  {3{ls0_srcpg_data_a1[20]}}, {3{ls0_srcpg_data_a1[19]}}, {3{ls0_srcpg_data_a1[18]}},
                                                        {3{ls0_srcpg_data_a1[17]}}, {3{ls0_srcpg_data_a1[16]}}, {3{ls0_srcpg_data_a1[15]}}, {3{ls0_srcpg_data_a1[14]}},
                                                        {3{ls0_srcpg_data_a1[13]}}, {3{ls0_srcpg_data_a1[12]}}, {3{ls0_srcpg_data_a1[11]}}, { {ls0_srcpg_data_a1[10]}}};
 
   assign ls0_ld3_st3_parsed_pred_a1_uop2[31:0] =    {{3{ls0_srcpg_data_a1[31]}}, {3{ls0_srcpg_data_a1[30]}}, {3{ls0_srcpg_data_a1[29]}},
                                                        {3{ls0_srcpg_data_a1[28]}}, {3{ls0_srcpg_data_a1[27]}}, {3{ls0_srcpg_data_a1[26]}}, {3{ls0_srcpg_data_a1[25]}},
                                                        {3{ls0_srcpg_data_a1[24]}}, {3{ls0_srcpg_data_a1[23]}}, {3{ls0_srcpg_data_a1[22]}}, {2{ls0_srcpg_data_a1[21]}}};
 

   assign ls0_ld4_st4_parsed_pred_a1_uop0[31:0] =   {{4{ls0_srcpg_data_a1[ 7]}}, {4{ls0_srcpg_data_a1[ 6]}}, {4{ls0_srcpg_data_a1[ 5]}}, {4{ls0_srcpg_data_a1[ 4]}},
                                                       {4{ls0_srcpg_data_a1[ 3]}}, {4{ls0_srcpg_data_a1[ 2]}}, {4{ls0_srcpg_data_a1[ 1]}}, {4{ls0_srcpg_data_a1[ 0]}}}; 

   assign ls0_ld4_st4_parsed_pred_a1_uop1[31:0] =   {{4{ls0_srcpg_data_a1[15]}}, {4{ls0_srcpg_data_a1[14]}}, {4{ls0_srcpg_data_a1[13]}}, {4{ls0_srcpg_data_a1[12]}}, 
                                                       {4{ls0_srcpg_data_a1[11]}}, {4{ls0_srcpg_data_a1[10]}}, {4{ls0_srcpg_data_a1[ 9]}}, {4{ls0_srcpg_data_a1[ 8]}}};
 
   assign ls0_ld4_st4_parsed_pred_a1_uop2[31:0] =   {{4{ls0_srcpg_data_a1[23]}}, {4{ls0_srcpg_data_a1[22]}}, {4{ls0_srcpg_data_a1[21]}}, {4{ls0_srcpg_data_a1[20]}},
                                                       {4{ls0_srcpg_data_a1[19]}}, {4{ls0_srcpg_data_a1[18]}}, {4{ls0_srcpg_data_a1[17]}}, {4{ls0_srcpg_data_a1[16]}}} ;

   assign ls0_ld4_st4_parsed_pred_a1_uop3[31:0] =   {{4{ls0_srcpg_data_a1[31]}}, {4{ls0_srcpg_data_a1[30]}}, {4{ls0_srcpg_data_a1[29]}}, {4{ls0_srcpg_data_a1[28]}}, 
                                                       {4{ls0_srcpg_data_a1[27]}}, {4{ls0_srcpg_data_a1[26]}}, {4{ls0_srcpg_data_a1[25]}}, {4{ls0_srcpg_data_a1[24]}}};
 
  

   assign ls0_ld2_st2_parsed_pred_a1_uop1_vl16[15:0] =  ls0_ld2_st2_parsed_pred_a1_uop0[31:16]; 

   assign ls0_ld4_st4_parsed_pred_a1_uop1_vl16[15:0] =  ls0_ld4_st4_parsed_pred_a1_uop0[31:16];
 
   assign ls0_ld4_st4_parsed_pred_a1_uop2_vl16[15:0] =   {{4{ls0_srcpg_data_a1[11]}}, {4{ls0_srcpg_data_a1[10]}}, {4{ls0_srcpg_data_a1[ 9]}}, {4{ls0_srcpg_data_a1[ 8]}}}; 
   assign ls0_ld4_st4_parsed_pred_a1_uop3_vl16[15:0] =   {{4{ls0_srcpg_data_a1[15]}}, {4{ls0_srcpg_data_a1[14]}}, {4{ls0_srcpg_data_a1[13]}}, {4{ls0_srcpg_data_a1[12]}}}; 
 
   assign ls0_ld3_st3_parsed_pred_a1_uop1_vl16[15:0] =  ls0_ld3_st3_parsed_pred_a1_uop0[31:16];
 
   assign ls0_ld3_st3_parsed_pred_a1_uop2_vl16[15:0] =  { {3{ls0_srcpg_data_a1[15]}},
                                                            {3{ls0_srcpg_data_a1[14]}}, {3{ls0_srcpg_data_a1[13]}}, {3{ls0_srcpg_data_a1[12]}}, {3{ls0_srcpg_data_a1[11]}}, 
                                                            {{ls0_srcpg_data_a1[10]}}};




   assign ls0_valid_multi_reg_ld_st_op_a1 = ~(|ls_uop_ctl_ls0_a1_q[5:4]) &  (&ls_uop_ctl_ls0_a1_q[3:2]) & (|ls_uop_ctl_ls0_a1_q[1:0]);
   assign ls0_multi_reg_ld_st_op_a1[1:0] =  {2{ls0_valid_multi_reg_ld_st_op_a1}} & ls_uop_ctl_ls0_a1_q[1:0]; 


  always_ff @(posedge clk)
  begin: u_ls0_valid_multi_reg_ld_st_op_a2_q
    if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY ls0_valid_multi_reg_ld_st_op_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_comb 
  begin: u_ls0_ld_st_multi_reg_parsed_pred_a1_15_0
    casez({ls0_vl16_a1, ls0_multi_reg_ld_st_op_a1[1:0], ls0_uop_num_a1[1:0]})
      5'b?_0?_?0: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld2_st2_parsed_pred_a1_uop0[15:0];  
      5'b0_0?_?1: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld2_st2_parsed_pred_a1_uop1[15:0];  
      5'b1_0?_?1: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld2_st2_parsed_pred_a1_uop1_vl16[15:0];  
      5'b?_10_00: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld3_st3_parsed_pred_a1_uop0[15:0];  
      5'b0_10_?1: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld3_st3_parsed_pred_a1_uop1[15:0];  
      5'b0_10_10: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld3_st3_parsed_pred_a1_uop2[15:0];  
      5'b1_10_?1: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld3_st3_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_10_10: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld3_st3_parsed_pred_a1_uop2_vl16[15:0];  
      5'b?_11_00: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop0[15:0];  
      5'b0_11_01: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop1[15:0];  
      5'b0_11_10: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop2[15:0];  
      5'b0_11_11: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop3[15:0];  
      5'b1_11_01: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_11_10: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop2_vl16[15:0];  
      5'b1_11_11: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = ls0_ld4_st4_parsed_pred_a1_uop3_vl16[15:0];  
      default: ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls0_vl16_a1, ls0_multi_reg_ld_st_op_a1[1:0], ls0_uop_num_a1[1:0]})) === 1'bx)
      ls0_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
`endif
  end



  always_comb 
  begin: u_ls0_ld_st_multi_reg_parsed_pred_a1_31_16
    casez({ls0_vl16_a1, ls0_multi_reg_ld_st_op_a1[1:0], ls0_uop_num_a1[1:0]})
      5'b0_0?_?0: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld2_st2_parsed_pred_a1_uop0[31:16];  
      5'b0_0?_?1: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld2_st2_parsed_pred_a1_uop1[31:16];  
      5'b0_10_00: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld3_st3_parsed_pred_a1_uop0[31:16];  
      5'b0_10_?1: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld3_st3_parsed_pred_a1_uop1[31:16];  
      5'b0_10_10: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld3_st3_parsed_pred_a1_uop2[31:16];  
      5'b0_11_00: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld4_st4_parsed_pred_a1_uop0[31:16];  
      5'b0_11_01: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld4_st4_parsed_pred_a1_uop1[31:16];  
      5'b0_11_10: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld4_st4_parsed_pred_a1_uop2[31:16];  
      5'b0_11_11: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = ls0_ld4_st4_parsed_pred_a1_uop3[31:16];  
      5'b1_??_??: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = 16'h0000;  
      default: ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls0_vl16_a1, ls0_multi_reg_ld_st_op_a1[1:0], ls0_uop_num_a1[1:0]})) === 1'bx)
      ls0_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
`endif
  end



   assign ls0_cont_parsed_pred_a1[31:16] = ls0_srcpg_data_a1[31:16]; 
   assign ls0_cont_parsed_pred_a1[15:8]  =  ({8{ls0_el_ln_size_b_h_a1}} & ls0_compact_pred_el_ln_size_b_h_a1[15:8] ) | 
                                              ({8{ls0_el_ln_size_h_w_a1}} & ls0_compact_pred_el_ln_size_h_w_a1[15:8] ) | 
                                              ({8{ls0_el_ln_size_w_d_a1}} & ls0_compact_pred_el_ln_size_w_d_a1[15:8] ) | 
                                              ({8{ls0_el_ln_size_eq_a1}}  & ls0_srcpg_data_a1[15:8]);


   assign ls0_cont_parsed_pred_a1[7:4]  =   ({4{ls0_el_ln_size_b_h_a1}} & ls0_compact_pred_el_ln_size_b_h_a1[7:4] ) | 
                                              ({4{ls0_el_ln_size_b_w_a1}} & ls0_compact_pred_el_ln_size_b_w_a1[7:4] ) | 
                                              ({4{ls0_el_ln_size_h_w_a1}} & ls0_compact_pred_el_ln_size_h_w_a1[7:4] ) | 
                                              ({4{ls0_el_ln_size_h_d_a1}} & ls0_compact_pred_el_ln_size_h_d_a1[7:4] ) | 
                                              ({4{ls0_el_ln_size_w_d_a1}} & ls0_compact_pred_el_ln_size_w_d_a1[7:4] ) | 
                                              ({4{ls0_el_ln_size_eq_a1}}  & ls0_srcpg_data_a1[7:4]);

   assign ls0_cont_parsed_pred_a1[3:0]  =   ({4{ls0_el_ln_size_b_h_a1}} & ls0_compact_pred_el_ln_size_b_h_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_b_w_a1}} & ls0_compact_pred_el_ln_size_b_w_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_b_d_a1}} & ls0_compact_pred_el_ln_size_b_d_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_h_w_a1}} & ls0_compact_pred_el_ln_size_h_w_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_h_d_a1}} & ls0_compact_pred_el_ln_size_h_d_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_w_d_a1}} & ls0_compact_pred_el_ln_size_w_d_a1[3:0] ) | 
                                              ({4{ls0_el_ln_size_eq_a1}}  & ls0_srcpg_data_a1[3:0]);



  always_comb 
  begin: u_ls0_scatter_gather_parsed_pred_a1_7_0
    casez({ls0_scatter_gather_ln_num_a1_q[2:0], ls0_element_size_a1[1:0]})
      5'b000_??: ls0_scatter_gather_parsed_pred_a1[7:0] = ls0_cont_parsed_pred_a1[7:0];  
      5'b001_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[1]};  
      5'b001_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[3:2]};  
      5'b001_10: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[7:4]};  
      5'b001_11: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[15:8]};  
      5'b010_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[2]};  
      5'b010_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[5:4]};  
      5'b010_10: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[11:8]};  
      5'b010_11: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[23:16]};  
      5'b011_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[3]};  
      5'b011_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[7:6]};  
      5'b011_10: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[15:12]};  
      5'b011_11: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[31:24]};  
      5'b100_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[4]};  
      5'b100_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[9:8]};  
      5'b100_1?: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[19:16]};  
      5'b101_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[5]};  
      5'b101_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[11:10]};  
      5'b101_1?: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[23:20]};  
      5'b110_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[6]};  
      5'b110_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[13:12]};  
      5'b110_1?: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[27:24]};  
      5'b111_00: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:1], ls0_cont_parsed_pred_a1[7]};  
      5'b111_01: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:2], ls0_cont_parsed_pred_a1[15:14]};  
      5'b111_1?: ls0_scatter_gather_parsed_pred_a1[7:0] = {ls0_cont_parsed_pred_a1[7:4], ls0_cont_parsed_pred_a1[31:28]};  
      default: ls0_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls0_scatter_gather_ln_num_a1_q[2:0], ls0_element_size_a1[1:0]})) === 1'bx)
      ls0_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
`endif
  end


   assign ls0_parsed_pred_a1[7:0] =   ls0_scatter_gather_v_a1_q       ?  ls0_scatter_gather_parsed_pred_a1[7:0] :
                                        ls0_valid_multi_reg_ld_st_op_a1 ? ls0_ld_st_multi_reg_parsed_pred_a1[7:0] : 
                                                                           ls0_cont_parsed_pred_a1[7:0];

  assign ls0_parsed_pred_a1[31:8] =   ls0_valid_multi_reg_ld_st_op_a1 ? ls0_ld_st_multi_reg_parsed_pred_a1[31:8] : 
                                                                            ls0_cont_parsed_pred_a1[31:8];




  always_comb 
  begin: u_ls0_pred_mask_15_0
    casez(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: ls0_pred_mask[15:0] = 16'h0001;  
      `RV_BC_SIZE_H: ls0_pred_mask[15:0] = 16'h0003;  
      `RV_BC_SIZE_W: ls0_pred_mask[15:0] = 16'h000f;  
      `RV_BC_SIZE_D: ls0_pred_mask[15:0] = 16'h00ff;  
      `RV_BC_SIZE_16: ls0_pred_mask[15:0] = 16'hffff;  
      `RV_BC_SIZE_32: ls0_pred_mask[15:0] = 16'hffff;  
      default: ls0_pred_mask[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      ls0_pred_mask[15:0] = {16{1'bx}};
`endif
  end




  always_comb 
  begin: u_total_size_mask_ls0_a1_31_0
    casez(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_mask_ls0_a1[31:0] = 32'h0000_0001;  
      `RV_BC_SIZE_H: total_size_mask_ls0_a1[31:0] = 32'h0000_0003;  
      `RV_BC_SIZE_W: total_size_mask_ls0_a1[31:0] = 32'h0000_000f;  
      `RV_BC_SIZE_D: total_size_mask_ls0_a1[31:0] = 32'h0000_00ff;  
      `RV_BC_SIZE_16: total_size_mask_ls0_a1[31:0] = 32'h0000_ffff;  
      `RV_BC_SIZE_32: total_size_mask_ls0_a1[31:0] = 32'hffff_ffff;  
      default: total_size_mask_ls0_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_mask_ls0_a1[31:0] = {32{1'bx}};
`endif
  end




  always_comb 
  begin: u_byte_access_map_pre_pg_split_ls0_a1_31_0
    casez(ls0_fast_va_a1[4:0])
      5'b00000: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'hffff_ffff;  
      5'b00001: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h7fff_ffff;  
      5'b00010: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h3fff_ffff;  
      5'b00011: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h1fff_ffff;  
      5'b00100: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0fff_ffff;  
      5'b00101: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h07ff_ffff;  
      5'b00110: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h03ff_ffff;  
      5'b00111: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h01ff_ffff;  
      5'b01000: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h00ff_ffff;  
      5'b01001: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h007f_ffff;  
      5'b01010: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h003f_ffff;  
      5'b01011: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h001f_ffff;  
      5'b01100: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h000f_ffff;  
      5'b01101: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0007_ffff;  
      5'b01110: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0003_ffff;  
      5'b01111: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0001_ffff;  
      5'b10000: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_ffff;  
      5'b10001: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_7fff;  
      5'b10010: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_3fff;  
      5'b10011: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_1fff;  
      5'b10100: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_0fff;  
      5'b10101: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_07ff;  
      5'b10110: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_03ff;  
      5'b10111: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_01ff;  
      5'b11000: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_00ff;  
      5'b11001: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_007f;  
      5'b11010: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_003f;  
      5'b11011: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_001f;  
      5'b11100: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_000f;  
      5'b11101: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_0007;  
      5'b11110: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_0003;  
      5'b11111: byte_access_map_pre_pg_split_ls0_a1[31:0] = 32'h0000_0001;  
      default: byte_access_map_pre_pg_split_ls0_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls0_fast_va_a1[4:0])) === 1'bx)
      byte_access_map_pre_pg_split_ls0_a1[31:0] = {32{1'bx}};
`endif
  end

  

   assign byte_access_map_pre_ls0_a1[31:0] =  ls0_page_split1_early_val_a1 ? byte_access_map_pre_pg_split_ls0_a1[31:0]  : 
                                                ls0_page_split2_a1_q         ? (total_size_mask_ls0_a1[31:0] >> bytes_to_page_split_ls0_a2_q[4:0] ) :
                                                                                  total_size_mask_ls0_a1[31:0] ;
                                                                               

  always_ff @(posedge clk)
  begin: u_bytes_to_page_split_ls0_a2_q_4_0
    if (ls0_page_split1_early_val_a1 == 1'b1)
      bytes_to_page_split_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY bytes_to_page_split_ls0_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls0_page_split1_early_val_a1 == 1'b0)
    begin
    end
    else
      bytes_to_page_split_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_comb 
  begin: u_lanes_to_page_split_ls0_a2_4_0
    casez(ls0_element_size_a2[1:0])
      2'b00: lanes_to_page_split_ls0_a2[4:0] = bytes_to_page_split_ls0_a2_q[4:0];  
      2'b01: lanes_to_page_split_ls0_a2[4:0] = {1'b0, bytes_to_page_split_ls0_a2_q[4:1]};  
      2'b10: lanes_to_page_split_ls0_a2[4:0] = {2'b0, bytes_to_page_split_ls0_a2_q[4:2]};  
      2'b11: lanes_to_page_split_ls0_a2[4:0] = {3'b0, bytes_to_page_split_ls0_a2_q[4:3]};  
      default: lanes_to_page_split_ls0_a2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls0_element_size_a2[1:0])) === 1'bx)
      lanes_to_page_split_ls0_a2[4:0] = {5{1'bx}};
`endif
  end



  always_comb 
  begin: u_total_size_decoded_ls0_a1_5_0
    casez(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_decoded_ls0_a1[5:0] = 6'h01;  
      `RV_BC_SIZE_H: total_size_decoded_ls0_a1[5:0] = 6'h02;  
      `RV_BC_SIZE_W: total_size_decoded_ls0_a1[5:0] = 6'h04;  
      `RV_BC_SIZE_D: total_size_decoded_ls0_a1[5:0] = 6'h08;  
      `RV_BC_SIZE_16: total_size_decoded_ls0_a1[5:0] = 6'h10;  
      `RV_BC_SIZE_32: total_size_decoded_ls0_a1[5:0] = 6'h20;  
      default: total_size_decoded_ls0_a1[5:0] = {6{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_decoded_ls0_a1[5:0] = {6{1'bx}};
`endif
  end





  

   assign ls0_parsed_pred_adjusted_a1[31:0] = ls0_page_split2_a1_q ?  ls0_parsed_pred_a1[31:0] >> bytes_to_page_split_ls0_a2_q[4:0]
                                                                       :  ls0_parsed_pred_a1[31:0]; 

   assign ls0_parsed_pred_adjusted_masked_a1[31:0] = ls0_parsed_pred_adjusted_a1[31:0] &  byte_access_map_pre_ls0_a1[31:0];

   assign first_vld_lane_found_ls0_a1 =  |ls0_parsed_pred_adjusted_masked_a1[31:0]; 

  always_comb 
  begin : first_active_byte_ls0
    integer i;
    first_active_byte_found_ls0_a1 = 1'b0;
    first_active_byte_ls0_a1[4:0] = 5'b0;
    for (i=0; i<32; i=i+1)
    begin : first_active_byte_loop_ls0
     if (ls0_parsed_pred_adjusted_a1[i] & ~first_active_byte_found_ls0_a1) 
     begin : first_active_byte_if_ls0_a1
      first_active_byte_found_ls0_a1 = 1'b1;
      first_active_byte_ls0_a1[4:0] = i;
     end
    end
  end


  always_ff @(posedge clk)
  begin: u_first_active_byte_pre_ls0_a1_4_0
    if (valid_xlat_uop_ls0_a1 == 1'b1)
      first_active_byte_pre_ls0_a1[4:0] <= `RV_BC_DFF_DELAY first_active_byte_ls0_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (valid_xlat_uop_ls0_a1 == 1'b0)
    begin
    end
    else
      first_active_byte_pre_ls0_a1[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign first_active_byte_ls0_a2[4:0] =   {5{ls0_srcpg_v_a2_q & ~(ld_val_ls0_a2_q & ls0_rep_ld_a2_q)}}
                                           & first_active_byte_pre_ls0_a1[4:0];


   assign byte_access_map_ls0_a1[31:0] =   
                                              ls0_ldg_ld_a1 ? 32'h0000_ffff :                                             
                                              byte_access_map_pre_ls0_a1[31:0]
                                           & (    {32{   ~ls0_srcpg_v_a1_q                         
                                                        | ld_val_ls0_a1 & ls0_rep_ld_a1          
                                                  }}
                                               |  ls0_parsed_pred_adjusted_a1[31:0]              
                                             )
                                          ;


  assign  bytes_to_page_split_ls0_a1[4:0] = bytes_to_cache_split_ls0_a1[4:0];




  assign {unused_bytes_ls0_a2[1:0], bytes_to_cache_split_ls0_a1[4:0]} = 7'h40 - {1'b0, ls0_cache_split2_a1_q ? va_ls0_a2_q[5:0] : ls0_fast_va_a1[5:0]};

   assign ls0_parsed_pred_split_adjusted_a1[31:0] = ls0_cache_split2_a1_q ?  ls0_parsed_pred_a1[31:0] >> bytes_to_cache_split_ls0_a1[4:0]
                                                                              :  ls0_parsed_pred_a1[31:0]; 

  assign ls0_split_adjusted_access_size_a1[5:0] = ls0_cache_split1_val_a1 ? {1'b0,bytes_to_cache_split_ls0_a1[4:0]}
                                                                              : total_size_decoded_ls0_a1[5:0] - ({1'b0,bytes_to_cache_split_ls0_a1[4:0]} & {6{ls0_cache_split2_a1_q}});


    assign byte_access_map_split_adjusted_ls0_a1[0] = ls0_split_adjusted_access_size_a1[5:0] > 6'd0;
    assign byte_access_map_split_adjusted_ls0_a1[1] = ls0_split_adjusted_access_size_a1[5:0] > 6'd1;
    assign byte_access_map_split_adjusted_ls0_a1[2] = ls0_split_adjusted_access_size_a1[5:0] > 6'd2;
    assign byte_access_map_split_adjusted_ls0_a1[3] = ls0_split_adjusted_access_size_a1[5:0] > 6'd3;
    assign byte_access_map_split_adjusted_ls0_a1[4] = ls0_split_adjusted_access_size_a1[5:0] > 6'd4;
    assign byte_access_map_split_adjusted_ls0_a1[5] = ls0_split_adjusted_access_size_a1[5:0] > 6'd5;
    assign byte_access_map_split_adjusted_ls0_a1[6] = ls0_split_adjusted_access_size_a1[5:0] > 6'd6;
    assign byte_access_map_split_adjusted_ls0_a1[7] = ls0_split_adjusted_access_size_a1[5:0] > 6'd7;
    assign byte_access_map_split_adjusted_ls0_a1[8] = ls0_split_adjusted_access_size_a1[5:0] > 6'd8;
    assign byte_access_map_split_adjusted_ls0_a1[9] = ls0_split_adjusted_access_size_a1[5:0] > 6'd9;
    assign byte_access_map_split_adjusted_ls0_a1[10] = ls0_split_adjusted_access_size_a1[5:0] > 6'd10;
    assign byte_access_map_split_adjusted_ls0_a1[11] = ls0_split_adjusted_access_size_a1[5:0] > 6'd11;
    assign byte_access_map_split_adjusted_ls0_a1[12] = ls0_split_adjusted_access_size_a1[5:0] > 6'd12;
    assign byte_access_map_split_adjusted_ls0_a1[13] = ls0_split_adjusted_access_size_a1[5:0] > 6'd13;
    assign byte_access_map_split_adjusted_ls0_a1[14] = ls0_split_adjusted_access_size_a1[5:0] > 6'd14;
    assign byte_access_map_split_adjusted_ls0_a1[15] = ls0_split_adjusted_access_size_a1[5:0] > 6'd15;
    assign byte_access_map_split_adjusted_ls0_a1[16] = ls0_split_adjusted_access_size_a1[5:0] > 6'd16;
    assign byte_access_map_split_adjusted_ls0_a1[17] = ls0_split_adjusted_access_size_a1[5:0] > 6'd17;
    assign byte_access_map_split_adjusted_ls0_a1[18] = ls0_split_adjusted_access_size_a1[5:0] > 6'd18;
    assign byte_access_map_split_adjusted_ls0_a1[19] = ls0_split_adjusted_access_size_a1[5:0] > 6'd19;
    assign byte_access_map_split_adjusted_ls0_a1[20] = ls0_split_adjusted_access_size_a1[5:0] > 6'd20;
    assign byte_access_map_split_adjusted_ls0_a1[21] = ls0_split_adjusted_access_size_a1[5:0] > 6'd21;
    assign byte_access_map_split_adjusted_ls0_a1[22] = ls0_split_adjusted_access_size_a1[5:0] > 6'd22;
    assign byte_access_map_split_adjusted_ls0_a1[23] = ls0_split_adjusted_access_size_a1[5:0] > 6'd23;
    assign byte_access_map_split_adjusted_ls0_a1[24] = ls0_split_adjusted_access_size_a1[5:0] > 6'd24;
    assign byte_access_map_split_adjusted_ls0_a1[25] = ls0_split_adjusted_access_size_a1[5:0] > 6'd25;
    assign byte_access_map_split_adjusted_ls0_a1[26] = ls0_split_adjusted_access_size_a1[5:0] > 6'd26;
    assign byte_access_map_split_adjusted_ls0_a1[27] = ls0_split_adjusted_access_size_a1[5:0] > 6'd27;
    assign byte_access_map_split_adjusted_ls0_a1[28] = ls0_split_adjusted_access_size_a1[5:0] > 6'd28;
    assign byte_access_map_split_adjusted_ls0_a1[29] = ls0_split_adjusted_access_size_a1[5:0] > 6'd29;
    assign byte_access_map_split_adjusted_ls0_a1[30] = ls0_split_adjusted_access_size_a1[5:0] > 6'd30;
    assign byte_access_map_split_adjusted_ls0_a1[31] = ls0_split_adjusted_access_size_a1[5:0] > 6'd31;

   assign ls0_parsed_pred_split_adjusted_masked_a1[31:0] = ls0_parsed_pred_split_adjusted_a1[31:0] &  byte_access_map_split_adjusted_ls0_a1[31:0];

   assign vld_split_lane_found_ls0_a1 = ~ls0_srcpg_v_a1_q | (ls0_rep_ld_a1 ? ~ls0_rep_pred_zero_a1 : (|ls0_parsed_pred_split_adjusted_masked_a1[31:0]));
  
   assign ls0_lo_pred_non_zero_a1 = (|(ls0_parsed_pred_a1[15:0] & ls0_pred_mask[15:0]));
   assign ls0_hi_pred_non_zero_a1 = (|(ls0_parsed_pred_a1[31:16] & ls0_pred_mask[15:0]));


   assign ls0_lo_pred_zero_a1 = ~ls0_lo_pred_non_zero_a1;
   assign ls0_hi_pred_zero_a1 = ~ls0_hi_pred_non_zero_a1;

   assign ls0_rep_ld_a1 = (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R);

   assign ls0_qrep_ld_a1 = ( ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ);

   assign ls0_rep_pred_zero_a1 = ~(|ls0_srcpg_data_a1[31:0]);




  
   assign ls0_spe_zero_pg_rep_qrep =   ls0_qrep_ld_a1                   ? ~(|ls0_parsed_pred_adjusted_masked_a1[15:0]):
                                       (~ls_sve_vl_256_q & ls0_rep_ld_a1) ? ~(|ls0_srcpg_data_pq_a1[15:0]) :
                                       ( ls_sve_vl_256_q & ls0_rep_ld_a1) ? ~(|ls0_srcpg_data_pq_a1[31:0]) :
                                                                                1'b0;
   assign ls0_spe_zero_pg_non_qrep =   ls_sve_vl_256_q ? ~(|ls0_parsed_pred_adjusted_masked_a1[31:0]) :
                                                           ~(|ls0_parsed_pred_adjusted_masked_a1[15:0]);

   assign ls0_spe_part_pg_non_qrep = ls_sve_vl_256_q ? |(~ls0_parsed_pred_adjusted_a1[31:0] & byte_access_map_pre_ls0_a1[31:0]) :
                                                         |(~ls0_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls0_a1[15:0]);

   assign ls0_spe_part_pg_uop_qrep = |(~ls0_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls0_a1[15:0]);
  
   assign ls0_spe_part_pg_rep_qrep =    ls0_qrep_ld_a1                    ?   ls0_spe_part_pg_uop_qrep     :
                                        (~ls_sve_vl_256_q & ls0_rep_ld_a1)  ? ~(&ls0_srcpg_data_pq_a1[15:0]) :
                                        ( ls_sve_vl_256_q & ls0_rep_ld_a1)  ? ~(&ls0_srcpg_data_pq_a1[31:0]) :
                                                                                  1'b0 ;

   assign ls0_spe_part_pg_uop     = (ls0_qrep_ld_a1 | ls0_rep_ld_a1) ? ls0_spe_part_pg_rep_qrep : ls0_spe_part_pg_non_qrep;
   assign ls0_spe_zero_pg_uop     = (ls0_qrep_ld_a1 | ls0_rep_ld_a1) ? ls0_spe_zero_pg_rep_qrep : ls0_spe_zero_pg_non_qrep;
   assign ls0_empty_predicate     = ls0_spe_zero_pg_uop & ls0_srcpg_v_a1_q;
   assign ls0_partial_predicate   = ls0_spe_part_pg_uop & ls0_srcpg_v_a1_q;
   

   assign ls0_pred_all_inv_a1 = ls0_srcpg_v_a1_q & (ls0_lo_pred_zero_a1 &  ( ( ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_T_SIZE] != `RV_BC_SIZE_32 ) | ls0_hi_pred_zero_a1)); 

   

   assign ls0_ccpass_st_mod_a1 =    ccpass_ls0_a1
                                   & ( ~ls0_pred_all_inv_a1
                                      | ls0_sp_align_flt_a1              
                                      | ls0_page_split2_a1_q 
                                        & ls0_sp_align_flt_a2_q)         
                                 ;
                                     

  always_ff @(posedge clk)
  begin: u_ls0_ccpass_st_a2_q
    if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_ccpass_st_a2_q <= `RV_BC_DFF_DELAY ls0_ccpass_st_mod_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_ccpass_st_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


   assign ls0_pred_inv_force_ccfail_a1 =   ls0_srcpg_v_a1_q 
                                          & ( ls0_rep_ld_a1 ? ls0_rep_pred_zero_a1 
                                                              : (  ~first_vld_lane_found_ls0_a1 
                                                                  & ~(ls0_page_split1_early_val_a1 & prevent_unalign_ls0_a1) 
                                                                )
                                            )
                                          & ~ls0_sp_align_flt_a1 ;              
                                           




 assign ls0_srcpg_data_pq_a1[31:0] = ls0_valid_multi_reg_ld_st_op_a1 ? ls0_ld_st_multi_reg_parsed_pred_a1[31:0] : 
                                       ls0_qrep_ld_a1 ? {16'h0000, ls0_srcpg_data_a1[15:0]} : 
                                                                     ls0_srcpg_data_a1[31:0];

 

  always_ff @(posedge clk)
  begin: u_ls0_srcpg_data_a2_q_31_0
    if (ls0_srcpg_v_a1_q == 1'b1)
      ls0_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY ls0_srcpg_data_pq_a1[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls0_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls0_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls0_ln_size_a2_q_1_0
    if (ls0_srcpg_v_a1_q == 1'b1)
      ls0_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY ls0_ln_size_a1_q[1:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls0_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls0_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`endif
  end


 





  always_comb 
  begin: u_contiguous_lane_vlds_ls0_a1_31_0
    casez(ls0_ln_size_a1_q[1:0])
      2'b00: contiguous_lane_vlds_ls0_a1[31:0] = ls0_srcpg_data_a1_q[31:0];  
      2'b01: contiguous_lane_vlds_ls0_a1[31:0] = {16'b0, ls0_srcpg_data_a1_q[30], ls0_srcpg_data_a1_q[28], ls0_srcpg_data_a1_q[26], ls0_srcpg_data_a1_q[24], ls0_srcpg_data_a1_q[22], ls0_srcpg_data_a1_q[20], ls0_srcpg_data_a1_q[18], ls0_srcpg_data_a1_q[16], ls0_srcpg_data_a1_q[14], ls0_srcpg_data_a1_q[12], ls0_srcpg_data_a1_q[10], ls0_srcpg_data_a1_q[8], ls0_srcpg_data_a1_q[6], ls0_srcpg_data_a1_q[4], ls0_srcpg_data_a1_q[2], ls0_srcpg_data_a1_q[0]};  
      2'b10: contiguous_lane_vlds_ls0_a1[31:0] = {24'b0, ls0_srcpg_data_a1_q[28], ls0_srcpg_data_a1_q[24], ls0_srcpg_data_a1_q[20], ls0_srcpg_data_a1_q[16], ls0_srcpg_data_a1_q[12], ls0_srcpg_data_a1_q[8], ls0_srcpg_data_a1_q[4], ls0_srcpg_data_a1_q[0]};  
      2'b11: contiguous_lane_vlds_ls0_a1[31:0] = {28'b0, ls0_srcpg_data_a1_q[24], ls0_srcpg_data_a1_q[16], ls0_srcpg_data_a1_q[8], ls0_srcpg_data_a1_q[0]};  
      default: contiguous_lane_vlds_ls0_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls0_ln_size_a1_q[1:0])) === 1'bx)
      contiguous_lane_vlds_ls0_a1[31:0] = {32{1'bx}};
`endif
  end


  always_comb 
  begin : find_raw_pred_first_active_lane_ls0_a1
    integer i;
    raw_pred_first_vld_lane_found_ls0_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_first_active_lane_loop_ls0_a1
     raw_pred_first_active_lane_dec_ls0_a1[i] = ~raw_pred_first_vld_lane_found_ls0_a1 & contiguous_lane_vlds_ls0_a1[i] ;
     if (contiguous_lane_vlds_ls0_a1[i])
     begin : find_raw_pred_first_active_lane_if_ls0_a1
      raw_pred_first_vld_lane_found_ls0_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_first_active_lane_ls0_a1_4_0
    raw_pred_first_active_lane_ls0_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_first_active_lane_dec_ls0_a1[macro_i])
        raw_pred_first_active_lane_ls0_a1[4:0] = raw_pred_first_active_lane_ls0_a1[4:0] | macro_i[4:0];
  end


  always_comb 
  begin : find_raw_pred_second_active_lane_ls0_a1
    integer i;
    raw_pred_first_vld_lane_found_2_ls0_a1 = 1'b0;
    raw_pred_second_vld_lane_found_ls0_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_second_active_lane_loop_ls0_a1
     raw_pred_second_lane_dec_ls0_a1[i] = ~(raw_pred_first_vld_lane_found_2_ls0_a1 & raw_pred_second_vld_lane_found_ls0_a1) & raw_pred_first_vld_lane_found_2_ls0_a1 & contiguous_lane_vlds_ls0_a1[i]  ;
     if (contiguous_lane_vlds_ls0_a1[i])
     begin : find_raw_pred_second_active_lane_if_1_ls0_a1
      if (raw_pred_first_vld_lane_found_2_ls0_a1)
      begin:  find_raw_pred_second_active_lane_if_2_ls0_a1
       raw_pred_second_vld_lane_found_ls0_a1= 1'b1;
      end
      raw_pred_first_vld_lane_found_2_ls0_a1= 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_second_lane_ls0_a1_4_0
    raw_pred_second_lane_ls0_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_second_lane_dec_ls0_a1[macro_i])
        raw_pred_second_lane_ls0_a1[4:0] = raw_pred_second_lane_ls0_a1[4:0] | macro_i[4:0];
  end


  assign ff_ld_ls0_a1 = unit_fault_only_first_ld_ls0_a1 | gather_fault_only_first_ld_ls0_a1;
  assign unalign_ls0_a1_a2 = unalign1_ls0_a1 | unalign2_ls0_a1_q ; 
  assign page_split_ls0_a1_a2 = ls0_page_split1_val_a1 | ls0_ld_page_split2_a1; 

  assign chk_bit_ff_ld_ffr_upd_poss_ls0_a1 = ld_val_ls0_a1 & (   unit_fault_only_first_ld_ls0_a1 & raw_pred_second_vld_lane_found_ls0_a1
                                                                   | gather_fault_only_first_ld_ls0_a1 & ~scatter_gather_cur_lane_eq_first_active_lane_ls0_a1
                                                                 ) ;

  assign chk_bit_nf_ld_ffr_upd_poss_ls0_a1 = ld_val_ls0_a1 & nf_ld_ls0_a1 & raw_pred_first_vld_lane_found_ls0_a1;

  assign chk_bit_ffr_upd_ls0_a1 =    (ls_ff_nf_ld_ffr_upd_always | ls_ff_nf_ld_ffr_cons_upd_on_exptn) & (chk_bit_ff_ld_ffr_upd_poss_ls0_a1 | chk_bit_nf_ld_ffr_upd_poss_ls0_a1)
                                     | ls_unalign_ff_ld_ffr_cons_upd_on_exptn     & chk_bit_ff_ld_ffr_upd_poss_ls0_a1 & unalign_ls0_a1_a2
                                     | ls_unalign_nf_ld_ffr_cons_upd_on_exptn     & chk_bit_nf_ld_ffr_upd_poss_ls0_a1 & unalign_ls0_a1_a2 
                                     | ls_page_split_ff_ld_ffr_cons_upd_on_exptn  & chk_bit_ff_ld_ffr_upd_poss_ls0_a1 & page_split_ls0_a1_a2
                                     | ls_page_split_nf_ld_ffr_cons_upd_on_exptn  & chk_bit_nf_ld_ffr_upd_poss_ls0_a1 & page_split_ls0_a1_a2; 

  assign chk_bit_ffr_lane_ls0_a1[4:0] = {5{ unit_fault_only_first_ld_ls0_a1}} & raw_pred_second_lane_ls0_a1[4:0] | 
                                        {5{~unit_fault_only_first_ld_ls0_a1}} & {2'b0, ls0_scatter_gather_ln_num_a1_q[2:0]};  


  always_ff @(posedge clk)
  begin: u_chk_bit_ffr_upd_ls0_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b1)
      chk_bit_ffr_upd_ls0_a2_q <= `RV_BC_DFF_DELAY chk_bit_ffr_upd_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_upd_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


 assign chk_bit_ffr_upd_clk_en_ls0_a1 =      ff_or_nf_ld_a2_flops_clk_en_ls0_a1 
                                             | ls_ff_nf_ld_ffr_upd_always 
                                             | ls_ff_nf_ld_ffr_cons_upd_on_exptn
                                             | ls_unalign_ff_ld_ffr_cons_upd_on_exptn    
                                             | ls_unalign_nf_ld_ffr_cons_upd_on_exptn    
                                             | ls_page_split_ff_ld_ffr_cons_upd_on_exptn 
                                             | ls_page_split_nf_ld_ffr_cons_upd_on_exptn;  
 

  always_ff @(posedge clk_agu0)
  begin: u_chk_bit_ffr_lane_ls0_a2_q_4_0
    if (chk_bit_ffr_upd_clk_en_ls0_a1 == 1'b1)
      chk_bit_ffr_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY chk_bit_ffr_lane_ls0_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (chk_bit_ffr_upd_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_comb 
  begin : find_page_split_lane_mask_ls0
    integer i;
    first_one_found_ls0_a2 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : page_split_lane_mask_loop_ls0
     if (lanes_to_page_split_ls0_a2[4:0] == i)
      first_one_found_ls0_a2 = 1'b1;
      page_split_lane_mask_ls0_a2[i] = first_one_found_ls0_a2;
    end
  end



   assign ffr_vlds_ls0_a1[31:0] =   (   {32{~ls0_page_split2_a1_q | not_nf_or_ff_cont_ld_ls0_a1}}                                                                                                                                | {{32{ls0_page_split2_a1_q}}    &  page_split_lane_mask_ls0_a2[31:0]}                                                    
                                      )
                                    &  contiguous_lane_vlds_ls0_a1[31:0]; 

  always_comb 
  begin : find_ffr_lane_ls0_a1
    integer i;
    vld_lane_found_ls0_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : ffr_lane_loop_ls0
     cont_ld_ffr_lane_dec_ls0_a1[i] = ~vld_lane_found_ls0_a1 & ffr_vlds_ls0_a1[i] ;
     if (ffr_vlds_ls0_a1[i])
     begin : first_vld_lane_found_if_ls0_a1
      vld_lane_found_ls0_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin : find_last_lane_ls0_a1
    integer i;
    vld_last_lane_found_ls0_a1 = 1'b0;
    for (i=31; i>=0; i=i-1)
    begin : last_lane_loop_ls0
     cont_ld_last_lane_dec_ls0_a1[i] = ~vld_last_lane_found_ls0_a1 & ffr_vlds_ls0_a1[i] ;
     if (ffr_vlds_ls0_a1[i])
     begin : first_vld_lane_found_if_ls0_a1
      vld_last_lane_found_ls0_a1 = 1'b1;
     end
    end
  end


  


  assign more_than_one_active_lane_pre_ls0_a1 = (cont_ld_ffr_lane_dec_ls0_a1[31:0] != cont_ld_last_lane_dec_ls0_a1[31:0]);


  always_ff @(posedge clk)
  begin: u_more_than_one_active_lane_pre_ls0_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b1)
      more_than_one_active_lane_pre_ls0_a2_q <= `RV_BC_DFF_DELAY more_than_one_active_lane_pre_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      more_than_one_active_lane_pre_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign more_than_one_active_lane_ls0_a2 =   ls0_page_split2_a1_q  & page_split1_more_than_one_active_lane_ls0_a2 
                                              | ls0_page_split2_a2_q  & first_vld_lane_found_ls0_a3_q
                                              | ~ls0_page_split2_a1_q & more_than_one_active_lane_pre_ls0_a2_q;


  assign page_split1_more_than_one_active_lane_ls0_a2 = (cont_ld_ffr_lane_ls0_a1[4:0] != raw_pred_second_lane_ls0_a2_q[4:0]) & ~(mid_first_lane_page_split_ls0_a2 & (|(ffr_vlds_ls0_a1[31:0]))) ;

  assign mid_first_lane_page_split_ls0_a2 = (ffr_lane_ls0_a2_q[4:0] == cont_ld_ffr_lane_ls0_a1[4:0]);



  always_comb 
  begin: u_cont_ld_ffr_lane_ls0_a1_4_0
    cont_ld_ffr_lane_ls0_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (cont_ld_ffr_lane_dec_ls0_a1[macro_i])
        cont_ld_ffr_lane_ls0_a1[4:0] = cont_ld_ffr_lane_ls0_a1[4:0] | macro_i[4:0];
  end





  assign ff_or_nf_ld_a2_flops_clk_en_ls0_a1 = (unit_fault_only_first_ld_ls0_a1 | gather_fault_only_first_ld_ls0_a1 | nf_ld_ls0_a1) & ld_val_ls0_a1; 


  always_ff @(posedge clk)
  begin: u_raw_pred_second_lane_ls0_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b1)
      raw_pred_second_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY raw_pred_second_lane_ls0_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      raw_pred_second_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign cont_ld_second_ffr_lane_ls0_a2[4:0] = ls0_page_split2_a2_q & first_vld_lane_found_ls0_a3_q & ~mid_first_lane_page_split_ls0_a3_q ? ffr_lane_ls0_a2_q[4:0]
                                                                                                                                                  : raw_pred_second_lane_ls0_a2_q[4:0];

  assign ffr_lane_ls0_a1[4:0] =  ( {5{~not_nf_or_ff_cont_ld_ls0_a1}} &  cont_ld_ffr_lane_ls0_a1[4:0])                   
                                 | ( {5{ gather_fault_only_first_ld_ls0_a1}}         & {2'b0, ls0_scatter_gather_ln_num_a1_q[2:0]}) ;   


  always_ff @(posedge clk)
  begin: u_ffr_lane_ls0_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b1)
      ffr_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY ffr_lane_ls0_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      ffr_lane_ls0_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_ff_cont_ld_ls0_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      ff_cont_ld_ls0_a2_q <= `RV_BC_DFF_DELAY unit_fault_only_first_ld_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ff_cont_ld_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_cont_ld_ls0_a2 = ld_val_ls0_a2_q & ff_cont_ld_ls0_a2_q;


  always_ff @(posedge clk)
  begin: u_nf_ld_ls0_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      nf_ld_ls0_a2_q <= `RV_BC_DFF_DELAY nf_ld_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      nf_ld_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign nf_ld_ls0_a2 = ld_val_ls0_a2_q & nf_ld_ls0_a2_q;


  always_ff @(posedge clk)
  begin: u_ff_gather_ld_ls0_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      ff_gather_ld_ls0_a2_q <= `RV_BC_DFF_DELAY gather_fault_only_first_ld_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ff_gather_ld_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls0_rep_ld_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      ls0_rep_ld_a2_q <= `RV_BC_DFF_DELAY ls0_rep_ld_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ls0_rep_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_gather_ld_ls0_a2 = ld_val_ls0_a2_q & ff_gather_ld_ls0_a2_q;

  assign ff_ld_ls0_a2 = ff_cont_ld_ls0_a2 | ff_gather_ld_ls0_a2;

  assign ff_or_nf_ld_ls0_a2 = ff_ld_ls0_a2 | nf_ld_ls0_a2 ;


  assign scatter_gather_cur_lane_eq_first_active_lane_ls0_a1 =    (ls0_scatter_gather_ln_num_a1_q[2:0] == cont_ld_ffr_lane_ls0_a1[2:0]);



  always_ff @(posedge clk)
  begin: u_scatter_gather_cur_lane_eq_first_active_lane_ls0_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b1)
      scatter_gather_cur_lane_eq_first_active_lane_ls0_a2_q <= `RV_BC_DFF_DELAY scatter_gather_cur_lane_eq_first_active_lane_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a1 == 1'b0)
    begin
    end
    else
      scatter_gather_cur_lane_eq_first_active_lane_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls0_a2_q
    if (any_issue_v_ls0_i2_a2 == 1'b1)
      first_vld_lane_found_ls0_a2_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls0_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_or_nf_ld_a2_flops_clk_en_ls0_a2 = ff_or_nf_ld_ls0_a2 & ld_val_ls0_a2_q; 


  always_ff @(posedge clk)
  begin: u_ffr_lane_eq_first_active_lane_ls0_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b1)
      ffr_lane_eq_first_active_lane_ls0_a3_q <= `RV_BC_DFF_DELAY ffr_lane_eq_first_active_lane_ls0_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b0)
    begin
    end
    else
      ffr_lane_eq_first_active_lane_ls0_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end





  always_ff @(posedge clk)
  begin: u_mid_first_lane_page_split_ls0_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b1)
      mid_first_lane_page_split_ls0_a3_q <= `RV_BC_DFF_DELAY mid_first_lane_page_split_ls0_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b0)
    begin
    end
    else
      mid_first_lane_page_split_ls0_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls0_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b1)
      first_vld_lane_found_ls0_a3_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls0_a2_q;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls0_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls0_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ffr_lane_eq_first_active_lane_ls0_a2 =   ls0_sp_align_flt_a2_q                                                                                      
                                                  | ( ~unit_fault_only_first_ld_ls0_a1              ? scatter_gather_cur_lane_eq_first_active_lane_ls0_a2_q :
                                                      ld_val_ls0_a2_q & ls0_page_split2_a2_q ?  (  ~ffr_lane_eq_first_active_lane_ls0_a3_q                 
 
                                                                                                      | mid_first_lane_page_split_ls0_a3_q                     
                                                                                                    ) &  first_vld_lane_found_ls0_a2_q   
                                                                                                 : first_vld_lane_found_ls0_a2_q
                                                    );  




  assign first_vld_lane_found_ls0_a2 =    first_vld_lane_found_ls0_a2_q
                                         |  ld_val_ls0_a2_q & ls0_rep_ld_a2_q            
                                         | ~ls0_srcpg_v_a2_q                               
                                         |  ls0_sp_align_flt_a2_q;                         





  assign ls0_ld_reject_gather_nxt_i2 = ls0_ld_reject_gather_i2 & issue_v_ls0_i2;

  rv_bc_dffr #(.W(1)) u_unalign2_ls0_a1_0 (.q(unalign2_ls0_a1_q),                            .din(unalign2_ls0_i2),                             .clk(clk), .en(any_issue_v_ls0_i2_a2), .reset(reset_i));
  rv_bc_dffr #(.W(1)) u_unalign2_ls0_a1_1 (.q(unalign2_dup_ls0_a1_q),                        .din(unalign2_ls0_i2),                             .clk(clk), .en(any_issue_v_ls0_i2_a2), .reset(reset_i));

  always_ff @(posedge clk or posedge reset_i)
  begin: u_unalign2_ls0_a2_q
    if (reset_i == 1'b1)
      unalign2_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      unalign2_ls0_a2_q <= `RV_BC_DFF_DELAY unalign2_ls0_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      unalign2_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      unalign2_ls0_a2_q <= `RV_BC_DFF_DELAY unalign2_ls0_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_page_split2_a1_q
    if (reset_i == 1'b1)
      ls0_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_page_split2_a1_q <= `RV_BC_DFF_DELAY ls0_page_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_page_split2_a1_q <= `RV_BC_DFF_DELAY ls0_page_split1_val_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_page_split2_a2_q
    if (reset_i == 1'b1)
      ls0_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_page_split2_a2_q <= `RV_BC_DFF_DELAY ls0_page_split2_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_page_split2_a2_q <= `RV_BC_DFF_DELAY ls0_page_split2_a1_q;
`endif
  end


  assign ls0_a1_reject_i2 =    ls0_ld_reject_gather_nxt_i2
                              |   ls_ff_nf_ld_ffr_upd_always & issue_ld_val_ls0_i2                                                             
                                & (   (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_CONT_FF_LD) 
                                    | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_FF_LD) 
                                    | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD) 
                                  )
                                & ~ls0_precommit_uop_i2_unqual
                                & ~address_inject_val_ls0_i2_q;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_a1_reject_a1_q
    if (reset_i == 1'b1)
      ls0_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls0_a1_reject_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls0_a1_reject_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls0_i2_q
    if (reset_i == 1'b1)
      address_inject_val_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls0_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_i1;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls0_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_i1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls0_a1_q
    if (reset_i == 1'b1)
      address_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_i2_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_i2_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls0_a2_q
    if (reset_i == 1'b1)
      address_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls0_a1_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls0_a1_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls0_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls0_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls0_a2_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls0_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls0_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls0_a1_q
    if (reset_i == 1'b1)
      spe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls0_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls0_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls0_a2_q
    if (reset_i == 1'b1)
      spe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls0_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls0_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls0_a1_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls0_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls0_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls0_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls0_a2_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls0_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls0_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls0_a1_q;
`endif
  end




  always_ff @(posedge clk)
  begin: u_uid_ls0_i2_q_8_0
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      uid_ls0_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY is_ls_uid_ls0_i1[`RV_BC_UID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      uid_ls0_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY {9{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_rid_ls0_i2_q
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      rid_ls0_i2_q <= `RV_BC_DFF_DELAY is_ls_rid_ls0_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      rid_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



   

  always_ff @(posedge clk)
  begin: u_ls0_stid_i2_q_6_0
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      ls0_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY is_ls_stid_ls0_i1[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      ls0_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resx_ls0_i2_q
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      dep_d4_resx_ls0_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resx_ls0_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resx_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resy_ls0_i2_q
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      dep_d4_resy_ls0_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resy_ls0_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resy_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resz_ls0_i2_q
    if (is_ls_issue_v_ls0_i1 == 1'b1)
      dep_d4_resz_ls0_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resz_ls0_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls0_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resz_ls0_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu0)
  begin: u_stid_ls0_a1_q_6_0
    if (issue_v_poss_ls0_i2 == 1'b1)
      stid_ls0_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY ls0_stid_i2_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      stid_ls0_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_tmp_ls_uop_ctl_ls0_a1_q_21_0
    if (issue_v_poss_ls0_i2 == 1'b1)
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SP_BASE:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY {22{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_tmp_ls_uop_ctl_ls0_a1_q_26
    if (issue_v_poss_ls0_i2 == 1'b1)
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_IL];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_tmp_ls_uop_ctl_ls0_a1_q_27
    if (issue_v_poss_ls0_i2 == 1'b1)
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_HSR_ISS_V];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_tmp_ls_uop_ctl_ls0_a1_q_32_28
    if (issue_v_poss_ls0_i2 == 1'b1)
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_HSR_ISS_RT];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_precommit_uop_a1_q
    if (reset_i == 1'b1)
      ls0_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls0_i2 == 1'b1)
      ls0_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls0_precommit_uop_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      ls0_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls0_i2 == 1'b1)
      ls0_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls0_precommit_uop_i2;
`endif
  end



  always_ff @(posedge clk)
  begin: u_stid_ls0_a2_q_6_0
    if (op_val_ls0_a1 == 1'b1)
      stid_ls0_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY stid_ls0_a1_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (op_val_ls0_a1 == 1'b0)
    begin
    end
    else
      stid_ls0_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] = tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT];
  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_V]  = tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_HSR_ISS_V];
  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_IL]         = tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_IL];
  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SP_BASE:0]  = tmp_ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SP_BASE:0];
  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SRCB_EXT]   = 2'b00; 
  assign ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SRCB_SH]    = 2'b00; 

  assign ls0_sp_base_a1            = ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_SP_BASE]; 

  assign ls0_ld_unalign1_a2        =  (ld_val_ls0_a2_q & unalign2_ls0_a1_q);
  assign ls0_ld_page_split1_a2     =  (ld_val_ls0_a2_q & ls0_page_split2_a1_q);
  assign ls0_st_page_split1_a2     =  (st_val_ls0_a2_q & ls0_page_split2_a1_q);

  assign ls0_ld_unalign2_a1        =  (ld_val_ls0_a2_q & unalign2_ls0_a1_q);
  assign ls0_ld_page_split2_a1     =  (ld_val_ls0_a2_q & ls0_page_split2_a1_q);


  assign pf_tlb_inject_v_ls0_i2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls0_i2_q & ~tmo_inject_val_ls0_i2   & ~spe_inject_val_ls0_i2 & ~tbe_inject_val_ls0_i2;
  assign pf_tlb_inject_v_ls0_a1    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls0_a1_q & ~tmo_inject_val_ls0_a1_q & ~spe_inject_val_ls0_a1_q & ~tbe_inject_val_ls0_a1_q;
  assign pf_tlb_inject_v_ls0_a2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls0_a2_q & ~tmo_inject_val_ls0_a2_q & ~spe_inject_val_ls0_a2_q & ~tbe_inject_val_ls0_a2_q;

  assign ls_is_uop_reject_ls0_d1   =  ls0_a1_reject_a1_q;

  assign any_issue_v_ls0_i2_a2 =  issue_v_ls0_i2_q
                                 | issue_ld_val_ls0_a1_q | issue_st_val_ls0_a1_q 
                                 |       ld_val_ls0_a2_q |       st_val_ls0_a2_q  
                                 | ls0_st_pf_on_rst_full_a1_q;


  assign issue_v_ls1_i1 = is_ls_issue_v_ls1_i1   & ~is_ls_issue_cancel_ls1_i1;

  rv_bc_flush_compare   u_ls1_uop_flush_i2 (
      .flush_match (ls1_uop_flush_i2),
      .flush       (flush),
      .flush_uid   (flush_uid[`RV_BC_UID]), 
      .uop_uid     (uid_ls1_i2_q[`RV_BC_UID]) 
    );




assign issue_v_ls1_i2 =       issue_v_ls1_i2_q & ~is_ls_issue_cancel_ls1_i2
                                             & (~ls1_uop_flush_i2 | address_inject_val_ls1_i2_q)
                                             & ~unalign2_ls1_i2                  
                                             & (~dep_d4_resx_ls1_i2_q | ~ls_is_resx_cancel_d4 | address_inject_val_ls1_i2_q)
                                             & (~dep_d4_resy_ls1_i2_q | ~ls_is_resy_cancel_d4 | address_inject_val_ls1_i2_q)
                                             & (~dep_d4_resz_ls1_i2_q | ~ls_is_resz_cancel_d4 | address_inject_val_ls1_i2_q);

assign issue_v_early_ls1_i2 =       issue_v_ls1_i2_q & ~is_ls_issue_cancel_ls1_i2
                                             &  ~unalign2_ls1_i2 ;           

assign issue_v_poss_ls1_i2  =       issue_v_ls1_i2_q
                                             &  ~unalign2_ls1_i2 ;

assign issue_cancel_ls1_i2  = ~address_inject_val_ls1_i2_q
                              & ( is_ls_issue_cancel_ls1_i2
                                | dep_d4_resx_ls1_i2_q & ls_is_resx_cancel_d4
                                | dep_d4_resy_ls1_i2_q & ls_is_resy_cancel_d4
                                | dep_d4_resz_ls1_i2_q & ls_is_resz_cancel_d4);

  assign op_val_ls1_a1 = (ld_val_ls1_a1 | st_val_ls1_a1) & ~unalign2_ls1_a1_q;
 
  assign ld_val_ls1_clken_a1 = ld_val_ls1_a1 & ~unalign2_ls1_a1_q;

  assign address_inject_val_ls1_i1 = is_ls_issue_v_ls1_i1 & is_ls_issue_type_ls1_i1 ;
  
  assign tmo_inject_val_ls1_i2 = address_inject_val_ls1_i2_q &  tmo_inject_outstanding_q;
  assign spe_inject_val_ls1_i2 = address_inject_val_ls1_i2_q &  spe_inject_outstanding_q;

  assign tbe_inject_val_ls1_i2 = address_inject_val_ls1_i2_q &  tbe_inject_outstanding_q;

  assign ls1_type_ldg_i2 = (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG);




  assign ld_val_ls1_arb_possible_i2 = (issue_ld_val_ls1_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ~(ls_enable_serialize_gather_q & iq1_gather_ld_i2) & ~ls1_ld_ssbb_blk_i2) | 
                                        (issue_ld_val_ls1_a1_q & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & unalign2_ls1_i2 & ~(ls_enable_serialize_gather_q & iq1_gather_ld_a1_q) & ~ls1_ld_ssbb_blk_a1_q) | 
                                        ( issue_v_ls1_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls1_i2 & rst_full_ls1_q ) ;

  assign ls1_st_pf_on_rst_full_i2 = ( issue_v_ls1_i2 & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls1_i2 & rst_full_ls1_q ) ;
  assign ls1_st_pf_on_rst_full_poss_i2 = ( issue_v_ls1_i2_q & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls1_i2 & rst_full_ls1_q ) ;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_v_ls1_i2_q
    if (reset_i == 1'b1)
      issue_v_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0)
      issue_v_ls1_i2_q <= `RV_BC_DFF_DELAY issue_v_ls1_i1;
    else
      issue_v_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else
      issue_v_ls1_i2_q <= `RV_BC_DFF_DELAY issue_v_ls1_i1;
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


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ld_val_ls1_a1_q
    if (reset_i == 1'b1)
      issue_ld_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      issue_ld_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls1_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ld_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      issue_ld_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls1_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls1_arb_possible_a1_q
    if (reset_i == 1'b1)
      ld_val_ls1_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ld_val_ls1_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls1_arb_possible_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls1_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ld_val_ls1_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls1_arb_possible_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_st_val_ls1_a1_q
    if (reset_i == 1'b1)
      issue_st_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      issue_st_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls1_a1_din;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      issue_st_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      issue_st_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls1_a1_din;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls1_a2_q
    if (reset_i == 1'b1)
      ld_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ld_val_ls1_a2_q <= `RV_BC_DFF_DELAY ld_val_ls1_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ld_val_ls1_a2_q <= `RV_BC_DFF_DELAY ld_val_ls1_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_st_val_ls1_a2_q
    if (reset_i == 1'b1)
      st_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      st_val_ls1_a2_q <= `RV_BC_DFF_DELAY st_val_ls1_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      st_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      st_val_ls1_a2_q <= `RV_BC_DFF_DELAY st_val_ls1_a1;
`endif
  end



  always_ff @(posedge clk_agu1)
  begin: u_ls1_frc_unchecked_a1_q
    if (issue_v_poss_ls1_i2 == 1'b1)
      ls1_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY is_ls_force_unchecked_ls1_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu1)
  begin: u_iq1_gather_ld_a1_q
    if (issue_v_poss_ls1_i2 == 1'b1)
      iq1_gather_ld_a1_q <= `RV_BC_DFF_DELAY iq1_gather_ld_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      iq1_gather_ld_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_iq1_gather_ld_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      iq1_gather_ld_a2_q <= `RV_BC_DFF_DELAY iq1_gather_ld_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      iq1_gather_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ls1_element_size_a1[2:0] = ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_E_SIZE];

   assign ls1_vl16_a1 = 1'b1;


  assign ls1_ld_unpred_sve_uop_i2 = issue_ld_val_ls1_i2 & ~address_inject_val_ls1_i2_q & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_UNPRED_LD);


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_ls1_ld_unpred_sve_uop_a1_q
    if (reset_i == 1'b1)
      ls1_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls1_i2 == 1'b1)
      ls1_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls1_ld_unpred_sve_uop_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls1_i2 == 1'b1)
      ls1_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls1_ld_unpred_sve_uop_i2;
`endif
  end


  assign iq1_gather_ld_i2 = ((ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) 
                            |  (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)) & ~address_inject_val_ls1_i2_q;

  assign is_ls_srcpg_v_ls1_qual_i2 = unalign2_ls1_i2 ? ls1_srcpg_v_a1_q : is_ls_srcpg_v_ls1_i2 & issue_v_early_ls1_i2;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_srcpg_v_a1_q
    if (reset_i == 1'b1)
      ls1_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls1_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls1_qual_i2;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls1_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls1_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls1_qual_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_srcpg_v_a2_q
    if (reset_i == 1'b1)
      ls1_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls1_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls1_srcpg_v_a1_q;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls1_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls1_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls1_srcpg_v_a1_q;
`endif
  end


  assign ls1_srcpg_data_i2[31:0] = {16'h0000, is_ls_srcpg_data_ls1_i2[15:0]};

  assign srcpg_issue_v_ls1_i2 = issue_v_poss_ls1_i2 & is_ls_srcpg_v_ls1_i2;
  

  always_ff @(posedge clk_agu1)
  begin: u_ls1_srcpg_data_a1_q_31_0
    if (srcpg_issue_v_ls1_i2 == 1'b1)
      ls1_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY ls1_srcpg_data_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (srcpg_issue_v_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  assign ls1_scatter_gather_v_i2 = issue_v_ls1_i2_q & ( (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)) |
                                                           (~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ( (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) | 
                                                                                                           (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD) |
                                                          (((ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD) | 
                                                           ((ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLI_MASK) == `RV_BC_LS_TYPE_PLI)) & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_RES_EXT] 
                                                                                                         ) 
                                                                                                            
                                                            )
                                                          ); 

  assign is_ls_dsty_vlreg_ls1_i2[1:0] =  {is_ls_dsty_vlreg_ls1_i2_q[1] | ls1_scatter_gather_v_i2, is_ls_dsty_vlreg_ls1_i2_q[0]} ;

  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_ls1_ln_size_a1_q_1_0
    if (reset_i == 1'b1)
      ls1_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls1_i2 == 1'b1)
      ls1_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls1_i2[1:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`else
    else if (srcpg_issue_v_ls1_i2 == 1'b1)
      ls1_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls1_i2[1:0];
`endif
  end


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_ls1_scatter_gather_ln_num_a1_q_2_0
    if (reset_i == 1'b1)
      ls1_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls1_i2 == 1'b1)
      ls1_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls1_i2_q[2:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'bx}};
`else
    else if (srcpg_issue_v_ls1_i2 == 1'b1)
      ls1_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls1_i2_q[2:0];
`endif
  end




  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_ls1_scatter_gather_v_a1_q
    if (reset_i == 1'b1)
      ls1_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls1_i2 == 1'b1)
      ls1_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls1_scatter_gather_v_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls1_i2 == 1'b1)
      ls1_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls1_scatter_gather_v_i2;
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls1_scatter_gather_v_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY ls1_scatter_gather_v_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end







  always_comb 
  begin: u_ls1_srcpg_data_a1_31_0
    case(ls1_ln_size_a1_q[1:0])
      2'b00: ls1_srcpg_data_a1[31:0] = ls1_srcpg_data_a1_q[31:0];  
      2'b01: ls1_srcpg_data_a1[31:0] = {{2{ls1_srcpg_data_a1_q[30]}}, {2{ls1_srcpg_data_a1_q[28]}}, {2{ls1_srcpg_data_a1_q[26]}}, {2{ls1_srcpg_data_a1_q[24]}}, {2{ls1_srcpg_data_a1_q[22]}}, {2{ls1_srcpg_data_a1_q[20]}}, {2{ls1_srcpg_data_a1_q[18]}}, {2{ls1_srcpg_data_a1_q[16]}}, {2{ls1_srcpg_data_a1_q[14]}}, {2{ls1_srcpg_data_a1_q[12]}}, {2{ls1_srcpg_data_a1_q[10]}}, {2{ls1_srcpg_data_a1_q[8]}}, {2{ls1_srcpg_data_a1_q[6]}}, {2{ls1_srcpg_data_a1_q[4]}}, {2{ls1_srcpg_data_a1_q[2]}}, {2{ls1_srcpg_data_a1_q[0]}}};  
      2'b10: ls1_srcpg_data_a1[31:0] = {{4{ls1_srcpg_data_a1_q[28]}}, {4{ls1_srcpg_data_a1_q[24]}}, {4{ls1_srcpg_data_a1_q[20]}}, {4{ls1_srcpg_data_a1_q[16]}}, {4{ls1_srcpg_data_a1_q[12]}}, {4{ls1_srcpg_data_a1_q[8]}}, {4{ls1_srcpg_data_a1_q[4]}}, {4{ls1_srcpg_data_a1_q[0]}}};  
      2'b11: ls1_srcpg_data_a1[31:0] = {{8{ls1_srcpg_data_a1_q[24]}}, {8{ls1_srcpg_data_a1_q[16]}}, {8{ls1_srcpg_data_a1_q[8]}}, {8{ls1_srcpg_data_a1_q[0]}}};  
      default: ls1_srcpg_data_a1[31:0] = {32{1'bx}};
    endcase
  end




   assign ls1_el_ln_size_b_h_a1 = (ls1_ln_size_a1_q[1:0] == 2'b01) & (ls1_element_size_a1[1:0] == 2'b00) ;
   assign ls1_el_ln_size_b_w_a1 = (ls1_ln_size_a1_q[1:0] == 2'b10) & (ls1_element_size_a1[1:0] == 2'b00) ;
   assign ls1_el_ln_size_b_d_a1 = (ls1_ln_size_a1_q[1:0] == 2'b11) & (ls1_element_size_a1[1:0] == 2'b00) ;
   assign ls1_el_ln_size_h_w_a1 = (ls1_ln_size_a1_q[1:0] == 2'b10) & (ls1_element_size_a1[1:0] == 2'b01) ;
   assign ls1_el_ln_size_h_d_a1 = (ls1_ln_size_a1_q[1:0] == 2'b11) & (ls1_element_size_a1[1:0] == 2'b01) ;
   assign ls1_el_ln_size_w_d_a1 = (ls1_ln_size_a1_q[1:0] == 2'b11) & (ls1_element_size_a1[1:0] == 2'b10) ;
   assign ls1_el_ln_size_eq_a1  = (ls1_ln_size_a1_q[1:0] == ls1_element_size_a1[1:0]) ;


   assign ls1_compact_pred_el_ln_size_b_h_a1[15:0] = {ls1_srcpg_data_a1_q[30], ls1_srcpg_data_a1_q[28], ls1_srcpg_data_a1_q[26], ls1_srcpg_data_a1_q[24], 
                                                  ls1_srcpg_data_a1_q[22], ls1_srcpg_data_a1_q[20], ls1_srcpg_data_a1_q[18], ls1_srcpg_data_a1_q[16],
                                                  ls1_srcpg_data_a1_q[14], ls1_srcpg_data_a1_q[12], ls1_srcpg_data_a1_q[10], ls1_srcpg_data_a1_q[ 8],
                                                  ls1_srcpg_data_a1_q[ 6], ls1_srcpg_data_a1_q[ 4], ls1_srcpg_data_a1_q[ 2], ls1_srcpg_data_a1_q[ 0]}; 

   assign ls1_compact_pred_el_ln_size_b_w_a1[7:0] =  {ls1_srcpg_data_a1_q[28], ls1_srcpg_data_a1_q[24],        
                                                  ls1_srcpg_data_a1_q[20], ls1_srcpg_data_a1_q[16],
                                                  ls1_srcpg_data_a1_q[12], ls1_srcpg_data_a1_q[ 8],
                                                  ls1_srcpg_data_a1_q[ 4], ls1_srcpg_data_a1_q[ 0]};

   assign ls1_compact_pred_el_ln_size_b_d_a1[3:0] =  {ls1_srcpg_data_a1_q[24],
                                                  ls1_srcpg_data_a1_q[16],
                                                  ls1_srcpg_data_a1_q[ 8],
                                                  ls1_srcpg_data_a1_q[ 0]};


   assign ls1_compact_pred_el_ln_size_h_w_a1[15:0] =  {{2{ls1_srcpg_data_a1_q[28]}}, {2{ls1_srcpg_data_a1_q[24]}},        
                                                   {2{ls1_srcpg_data_a1_q[20]}}, {2{ls1_srcpg_data_a1_q[16]}},
                                                   {2{ls1_srcpg_data_a1_q[12]}}, {2{ls1_srcpg_data_a1_q[ 8]}},
                                                   {2{ls1_srcpg_data_a1_q[ 4]}}, {2{ls1_srcpg_data_a1_q[ 0]}}};

   assign ls1_compact_pred_el_ln_size_h_d_a1[7:0] =  {{2{ls1_srcpg_data_a1_q[24]}},
                                                  {2{ls1_srcpg_data_a1_q[16]}},
                                                  {2{ls1_srcpg_data_a1_q[ 8]}},
                                                  {2{ls1_srcpg_data_a1_q[ 0]}}};

   assign ls1_compact_pred_el_ln_size_w_d_a1[15:0] =  {{4{ls1_srcpg_data_a1_q[24]}},
                                                         {4{ls1_srcpg_data_a1_q[16]}},
                                                         {4{ls1_srcpg_data_a1_q[ 8]}},
                                                         {4{ls1_srcpg_data_a1_q[ 0]}}};

 
   assign ls1_ld2_st2_a1 = (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2);
   assign ls1_ld3_st3_a1 = (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3);
   assign ls1_ld4_st4_a1 = (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4);

   assign ls1_uop_num_a1[1:0] = {2{ls1_valid_multi_reg_ld_st_op_a1}} & ls1_scatter_gather_ln_num_a1_q[1:0];  


   assign ls1_ld2_st2_parsed_pred_a1_uop0[31:0] =   {{2{ls1_srcpg_data_a1[15]}}, {2{ls1_srcpg_data_a1[14]}}, {2{ls1_srcpg_data_a1[13]}}, {2{ls1_srcpg_data_a1[12]}}, 
                                                       {2{ls1_srcpg_data_a1[11]}}, {2{ls1_srcpg_data_a1[10]}}, {2{ls1_srcpg_data_a1[ 9]}}, {2{ls1_srcpg_data_a1[ 8]}},
                                                       {2{ls1_srcpg_data_a1[ 7]}}, {2{ls1_srcpg_data_a1[ 6]}}, {2{ls1_srcpg_data_a1[ 5]}}, {2{ls1_srcpg_data_a1[ 4]}},
                                                       {2{ls1_srcpg_data_a1[ 3]}}, {2{ls1_srcpg_data_a1[ 2]}}, {2{ls1_srcpg_data_a1[ 1]}}, {2{ls1_srcpg_data_a1[ 0]}}}; 

   assign ls1_ld2_st2_parsed_pred_a1_uop1[31:0] =   {{2{ls1_srcpg_data_a1[31]}}, {2{ls1_srcpg_data_a1[30]}}, {2{ls1_srcpg_data_a1[29]}}, {2{ls1_srcpg_data_a1[28]}}, 
                                                       {2{ls1_srcpg_data_a1[27]}}, {2{ls1_srcpg_data_a1[26]}}, {2{ls1_srcpg_data_a1[25]}}, {2{ls1_srcpg_data_a1[24]}},
                                                       {2{ls1_srcpg_data_a1[23]}}, {2{ls1_srcpg_data_a1[22]}}, {2{ls1_srcpg_data_a1[21]}}, {2{ls1_srcpg_data_a1[20]}},
                                                       {2{ls1_srcpg_data_a1[19]}}, {2{ls1_srcpg_data_a1[18]}}, {2{ls1_srcpg_data_a1[17]}}, {2{ls1_srcpg_data_a1[16]}}};

 
   assign ls1_ld3_st3_parsed_pred_a1_uop0[31:0] =   {{2{ls1_srcpg_data_a1[10]}}, {3{ls1_srcpg_data_a1[ 9]}}, {3{ls1_srcpg_data_a1[ 8]}},
                                                       {3{ls1_srcpg_data_a1[ 7]}}, {3{ls1_srcpg_data_a1[ 6]}}, {3{ls1_srcpg_data_a1[ 5]}}, {3{ls1_srcpg_data_a1[ 4]}},
                                                       {3{ls1_srcpg_data_a1[ 3]}}, {3{ls1_srcpg_data_a1[ 2]}}, {3{ls1_srcpg_data_a1[ 1]}}, {3{ls1_srcpg_data_a1[ 0]}}}; 

   assign ls1_ld3_st3_parsed_pred_a1_uop1[31:0] =    {{{ls1_srcpg_data_a1[21]}},  {3{ls1_srcpg_data_a1[20]}}, {3{ls1_srcpg_data_a1[19]}}, {3{ls1_srcpg_data_a1[18]}},
                                                        {3{ls1_srcpg_data_a1[17]}}, {3{ls1_srcpg_data_a1[16]}}, {3{ls1_srcpg_data_a1[15]}}, {3{ls1_srcpg_data_a1[14]}},
                                                        {3{ls1_srcpg_data_a1[13]}}, {3{ls1_srcpg_data_a1[12]}}, {3{ls1_srcpg_data_a1[11]}}, { {ls1_srcpg_data_a1[10]}}};
 
   assign ls1_ld3_st3_parsed_pred_a1_uop2[31:0] =    {{3{ls1_srcpg_data_a1[31]}}, {3{ls1_srcpg_data_a1[30]}}, {3{ls1_srcpg_data_a1[29]}},
                                                        {3{ls1_srcpg_data_a1[28]}}, {3{ls1_srcpg_data_a1[27]}}, {3{ls1_srcpg_data_a1[26]}}, {3{ls1_srcpg_data_a1[25]}},
                                                        {3{ls1_srcpg_data_a1[24]}}, {3{ls1_srcpg_data_a1[23]}}, {3{ls1_srcpg_data_a1[22]}}, {2{ls1_srcpg_data_a1[21]}}};
 

   assign ls1_ld4_st4_parsed_pred_a1_uop0[31:0] =   {{4{ls1_srcpg_data_a1[ 7]}}, {4{ls1_srcpg_data_a1[ 6]}}, {4{ls1_srcpg_data_a1[ 5]}}, {4{ls1_srcpg_data_a1[ 4]}},
                                                       {4{ls1_srcpg_data_a1[ 3]}}, {4{ls1_srcpg_data_a1[ 2]}}, {4{ls1_srcpg_data_a1[ 1]}}, {4{ls1_srcpg_data_a1[ 0]}}}; 

   assign ls1_ld4_st4_parsed_pred_a1_uop1[31:0] =   {{4{ls1_srcpg_data_a1[15]}}, {4{ls1_srcpg_data_a1[14]}}, {4{ls1_srcpg_data_a1[13]}}, {4{ls1_srcpg_data_a1[12]}}, 
                                                       {4{ls1_srcpg_data_a1[11]}}, {4{ls1_srcpg_data_a1[10]}}, {4{ls1_srcpg_data_a1[ 9]}}, {4{ls1_srcpg_data_a1[ 8]}}};
 
   assign ls1_ld4_st4_parsed_pred_a1_uop2[31:0] =   {{4{ls1_srcpg_data_a1[23]}}, {4{ls1_srcpg_data_a1[22]}}, {4{ls1_srcpg_data_a1[21]}}, {4{ls1_srcpg_data_a1[20]}},
                                                       {4{ls1_srcpg_data_a1[19]}}, {4{ls1_srcpg_data_a1[18]}}, {4{ls1_srcpg_data_a1[17]}}, {4{ls1_srcpg_data_a1[16]}}} ;

   assign ls1_ld4_st4_parsed_pred_a1_uop3[31:0] =   {{4{ls1_srcpg_data_a1[31]}}, {4{ls1_srcpg_data_a1[30]}}, {4{ls1_srcpg_data_a1[29]}}, {4{ls1_srcpg_data_a1[28]}}, 
                                                       {4{ls1_srcpg_data_a1[27]}}, {4{ls1_srcpg_data_a1[26]}}, {4{ls1_srcpg_data_a1[25]}}, {4{ls1_srcpg_data_a1[24]}}};
 
  

   assign ls1_ld2_st2_parsed_pred_a1_uop1_vl16[15:0] =  ls1_ld2_st2_parsed_pred_a1_uop0[31:16]; 

   assign ls1_ld4_st4_parsed_pred_a1_uop1_vl16[15:0] =  ls1_ld4_st4_parsed_pred_a1_uop0[31:16];
 
   assign ls1_ld4_st4_parsed_pred_a1_uop2_vl16[15:0] =   {{4{ls1_srcpg_data_a1[11]}}, {4{ls1_srcpg_data_a1[10]}}, {4{ls1_srcpg_data_a1[ 9]}}, {4{ls1_srcpg_data_a1[ 8]}}}; 
   assign ls1_ld4_st4_parsed_pred_a1_uop3_vl16[15:0] =   {{4{ls1_srcpg_data_a1[15]}}, {4{ls1_srcpg_data_a1[14]}}, {4{ls1_srcpg_data_a1[13]}}, {4{ls1_srcpg_data_a1[12]}}}; 
 
   assign ls1_ld3_st3_parsed_pred_a1_uop1_vl16[15:0] =  ls1_ld3_st3_parsed_pred_a1_uop0[31:16];
 
   assign ls1_ld3_st3_parsed_pred_a1_uop2_vl16[15:0] =  { {3{ls1_srcpg_data_a1[15]}},
                                                            {3{ls1_srcpg_data_a1[14]}}, {3{ls1_srcpg_data_a1[13]}}, {3{ls1_srcpg_data_a1[12]}}, {3{ls1_srcpg_data_a1[11]}}, 
                                                            {{ls1_srcpg_data_a1[10]}}};




   assign ls1_valid_multi_reg_ld_st_op_a1 = ~(|ls_uop_ctl_ls1_a1_q[5:4]) &  (&ls_uop_ctl_ls1_a1_q[3:2]) & (|ls_uop_ctl_ls1_a1_q[1:0]);
   assign ls1_multi_reg_ld_st_op_a1[1:0] =  {2{ls1_valid_multi_reg_ld_st_op_a1}} & ls_uop_ctl_ls1_a1_q[1:0]; 


  always_ff @(posedge clk)
  begin: u_ls1_valid_multi_reg_ld_st_op_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY ls1_valid_multi_reg_ld_st_op_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_comb 
  begin: u_ls1_ld_st_multi_reg_parsed_pred_a1_15_0
    casez({ls1_vl16_a1, ls1_multi_reg_ld_st_op_a1[1:0], ls1_uop_num_a1[1:0]})
      5'b?_0?_?0: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld2_st2_parsed_pred_a1_uop0[15:0];  
      5'b0_0?_?1: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld2_st2_parsed_pred_a1_uop1[15:0];  
      5'b1_0?_?1: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld2_st2_parsed_pred_a1_uop1_vl16[15:0];  
      5'b?_10_00: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld3_st3_parsed_pred_a1_uop0[15:0];  
      5'b0_10_?1: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld3_st3_parsed_pred_a1_uop1[15:0];  
      5'b0_10_10: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld3_st3_parsed_pred_a1_uop2[15:0];  
      5'b1_10_?1: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld3_st3_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_10_10: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld3_st3_parsed_pred_a1_uop2_vl16[15:0];  
      5'b?_11_00: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop0[15:0];  
      5'b0_11_01: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop1[15:0];  
      5'b0_11_10: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop2[15:0];  
      5'b0_11_11: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop3[15:0];  
      5'b1_11_01: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_11_10: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop2_vl16[15:0];  
      5'b1_11_11: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = ls1_ld4_st4_parsed_pred_a1_uop3_vl16[15:0];  
      default: ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls1_vl16_a1, ls1_multi_reg_ld_st_op_a1[1:0], ls1_uop_num_a1[1:0]})) === 1'bx)
      ls1_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
`endif
  end



  always_comb 
  begin: u_ls1_ld_st_multi_reg_parsed_pred_a1_31_16
    casez({ls1_vl16_a1, ls1_multi_reg_ld_st_op_a1[1:0], ls1_uop_num_a1[1:0]})
      5'b0_0?_?0: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld2_st2_parsed_pred_a1_uop0[31:16];  
      5'b0_0?_?1: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld2_st2_parsed_pred_a1_uop1[31:16];  
      5'b0_10_00: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld3_st3_parsed_pred_a1_uop0[31:16];  
      5'b0_10_?1: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld3_st3_parsed_pred_a1_uop1[31:16];  
      5'b0_10_10: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld3_st3_parsed_pred_a1_uop2[31:16];  
      5'b0_11_00: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld4_st4_parsed_pred_a1_uop0[31:16];  
      5'b0_11_01: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld4_st4_parsed_pred_a1_uop1[31:16];  
      5'b0_11_10: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld4_st4_parsed_pred_a1_uop2[31:16];  
      5'b0_11_11: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = ls1_ld4_st4_parsed_pred_a1_uop3[31:16];  
      5'b1_??_??: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = 16'h0000;  
      default: ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls1_vl16_a1, ls1_multi_reg_ld_st_op_a1[1:0], ls1_uop_num_a1[1:0]})) === 1'bx)
      ls1_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
`endif
  end



   assign ls1_cont_parsed_pred_a1[31:16] = ls1_srcpg_data_a1[31:16]; 
   assign ls1_cont_parsed_pred_a1[15:8]  =  ({8{ls1_el_ln_size_b_h_a1}} & ls1_compact_pred_el_ln_size_b_h_a1[15:8] ) | 
                                              ({8{ls1_el_ln_size_h_w_a1}} & ls1_compact_pred_el_ln_size_h_w_a1[15:8] ) | 
                                              ({8{ls1_el_ln_size_w_d_a1}} & ls1_compact_pred_el_ln_size_w_d_a1[15:8] ) | 
                                              ({8{ls1_el_ln_size_eq_a1}}  & ls1_srcpg_data_a1[15:8]);


   assign ls1_cont_parsed_pred_a1[7:4]  =   ({4{ls1_el_ln_size_b_h_a1}} & ls1_compact_pred_el_ln_size_b_h_a1[7:4] ) | 
                                              ({4{ls1_el_ln_size_b_w_a1}} & ls1_compact_pred_el_ln_size_b_w_a1[7:4] ) | 
                                              ({4{ls1_el_ln_size_h_w_a1}} & ls1_compact_pred_el_ln_size_h_w_a1[7:4] ) | 
                                              ({4{ls1_el_ln_size_h_d_a1}} & ls1_compact_pred_el_ln_size_h_d_a1[7:4] ) | 
                                              ({4{ls1_el_ln_size_w_d_a1}} & ls1_compact_pred_el_ln_size_w_d_a1[7:4] ) | 
                                              ({4{ls1_el_ln_size_eq_a1}}  & ls1_srcpg_data_a1[7:4]);

   assign ls1_cont_parsed_pred_a1[3:0]  =   ({4{ls1_el_ln_size_b_h_a1}} & ls1_compact_pred_el_ln_size_b_h_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_b_w_a1}} & ls1_compact_pred_el_ln_size_b_w_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_b_d_a1}} & ls1_compact_pred_el_ln_size_b_d_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_h_w_a1}} & ls1_compact_pred_el_ln_size_h_w_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_h_d_a1}} & ls1_compact_pred_el_ln_size_h_d_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_w_d_a1}} & ls1_compact_pred_el_ln_size_w_d_a1[3:0] ) | 
                                              ({4{ls1_el_ln_size_eq_a1}}  & ls1_srcpg_data_a1[3:0]);



  always_comb 
  begin: u_ls1_scatter_gather_parsed_pred_a1_7_0
    casez({ls1_scatter_gather_ln_num_a1_q[2:0], ls1_element_size_a1[1:0]})
      5'b000_??: ls1_scatter_gather_parsed_pred_a1[7:0] = ls1_cont_parsed_pred_a1[7:0];  
      5'b001_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[1]};  
      5'b001_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[3:2]};  
      5'b001_10: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[7:4]};  
      5'b001_11: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[15:8]};  
      5'b010_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[2]};  
      5'b010_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[5:4]};  
      5'b010_10: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[11:8]};  
      5'b010_11: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[23:16]};  
      5'b011_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[3]};  
      5'b011_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[7:6]};  
      5'b011_10: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[15:12]};  
      5'b011_11: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[31:24]};  
      5'b100_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[4]};  
      5'b100_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[9:8]};  
      5'b100_1?: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[19:16]};  
      5'b101_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[5]};  
      5'b101_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[11:10]};  
      5'b101_1?: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[23:20]};  
      5'b110_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[6]};  
      5'b110_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[13:12]};  
      5'b110_1?: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[27:24]};  
      5'b111_00: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:1], ls1_cont_parsed_pred_a1[7]};  
      5'b111_01: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:2], ls1_cont_parsed_pred_a1[15:14]};  
      5'b111_1?: ls1_scatter_gather_parsed_pred_a1[7:0] = {ls1_cont_parsed_pred_a1[7:4], ls1_cont_parsed_pred_a1[31:28]};  
      default: ls1_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls1_scatter_gather_ln_num_a1_q[2:0], ls1_element_size_a1[1:0]})) === 1'bx)
      ls1_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
`endif
  end


   assign ls1_parsed_pred_a1[7:0] =   ls1_scatter_gather_v_a1_q       ?  ls1_scatter_gather_parsed_pred_a1[7:0] :
                                        ls1_valid_multi_reg_ld_st_op_a1 ? ls1_ld_st_multi_reg_parsed_pred_a1[7:0] : 
                                                                           ls1_cont_parsed_pred_a1[7:0];

  assign ls1_parsed_pred_a1[31:8] =   ls1_valid_multi_reg_ld_st_op_a1 ? ls1_ld_st_multi_reg_parsed_pred_a1[31:8] : 
                                                                            ls1_cont_parsed_pred_a1[31:8];




  always_comb 
  begin: u_ls1_pred_mask_15_0
    casez(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: ls1_pred_mask[15:0] = 16'h0001;  
      `RV_BC_SIZE_H: ls1_pred_mask[15:0] = 16'h0003;  
      `RV_BC_SIZE_W: ls1_pred_mask[15:0] = 16'h000f;  
      `RV_BC_SIZE_D: ls1_pred_mask[15:0] = 16'h00ff;  
      `RV_BC_SIZE_16: ls1_pred_mask[15:0] = 16'hffff;  
      `RV_BC_SIZE_32: ls1_pred_mask[15:0] = 16'hffff;  
      default: ls1_pred_mask[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      ls1_pred_mask[15:0] = {16{1'bx}};
`endif
  end




  always_comb 
  begin: u_total_size_mask_ls1_a1_31_0
    casez(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_mask_ls1_a1[31:0] = 32'h0000_0001;  
      `RV_BC_SIZE_H: total_size_mask_ls1_a1[31:0] = 32'h0000_0003;  
      `RV_BC_SIZE_W: total_size_mask_ls1_a1[31:0] = 32'h0000_000f;  
      `RV_BC_SIZE_D: total_size_mask_ls1_a1[31:0] = 32'h0000_00ff;  
      `RV_BC_SIZE_16: total_size_mask_ls1_a1[31:0] = 32'h0000_ffff;  
      `RV_BC_SIZE_32: total_size_mask_ls1_a1[31:0] = 32'hffff_ffff;  
      default: total_size_mask_ls1_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_mask_ls1_a1[31:0] = {32{1'bx}};
`endif
  end




  always_comb 
  begin: u_byte_access_map_pre_pg_split_ls1_a1_31_0
    casez(ls1_fast_va_a1[4:0])
      5'b00000: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'hffff_ffff;  
      5'b00001: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h7fff_ffff;  
      5'b00010: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h3fff_ffff;  
      5'b00011: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h1fff_ffff;  
      5'b00100: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0fff_ffff;  
      5'b00101: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h07ff_ffff;  
      5'b00110: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h03ff_ffff;  
      5'b00111: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h01ff_ffff;  
      5'b01000: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h00ff_ffff;  
      5'b01001: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h007f_ffff;  
      5'b01010: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h003f_ffff;  
      5'b01011: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h001f_ffff;  
      5'b01100: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h000f_ffff;  
      5'b01101: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0007_ffff;  
      5'b01110: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0003_ffff;  
      5'b01111: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0001_ffff;  
      5'b10000: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_ffff;  
      5'b10001: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_7fff;  
      5'b10010: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_3fff;  
      5'b10011: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_1fff;  
      5'b10100: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_0fff;  
      5'b10101: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_07ff;  
      5'b10110: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_03ff;  
      5'b10111: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_01ff;  
      5'b11000: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_00ff;  
      5'b11001: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_007f;  
      5'b11010: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_003f;  
      5'b11011: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_001f;  
      5'b11100: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_000f;  
      5'b11101: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_0007;  
      5'b11110: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_0003;  
      5'b11111: byte_access_map_pre_pg_split_ls1_a1[31:0] = 32'h0000_0001;  
      default: byte_access_map_pre_pg_split_ls1_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls1_fast_va_a1[4:0])) === 1'bx)
      byte_access_map_pre_pg_split_ls1_a1[31:0] = {32{1'bx}};
`endif
  end

  

   assign byte_access_map_pre_ls1_a1[31:0] =  ls1_page_split1_early_val_a1 ? byte_access_map_pre_pg_split_ls1_a1[31:0]  : 
                                                ls1_page_split2_a1_q         ? (total_size_mask_ls1_a1[31:0] >> bytes_to_page_split_ls1_a2_q[4:0] ) :
                                                                                  total_size_mask_ls1_a1[31:0] ;
                                                                               

  always_ff @(posedge clk)
  begin: u_bytes_to_page_split_ls1_a2_q_4_0
    if (ls1_page_split1_early_val_a1 == 1'b1)
      bytes_to_page_split_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY bytes_to_page_split_ls1_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls1_page_split1_early_val_a1 == 1'b0)
    begin
    end
    else
      bytes_to_page_split_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_comb 
  begin: u_lanes_to_page_split_ls1_a2_4_0
    casez(ls1_element_size_a2[1:0])
      2'b00: lanes_to_page_split_ls1_a2[4:0] = bytes_to_page_split_ls1_a2_q[4:0];  
      2'b01: lanes_to_page_split_ls1_a2[4:0] = {1'b0, bytes_to_page_split_ls1_a2_q[4:1]};  
      2'b10: lanes_to_page_split_ls1_a2[4:0] = {2'b0, bytes_to_page_split_ls1_a2_q[4:2]};  
      2'b11: lanes_to_page_split_ls1_a2[4:0] = {3'b0, bytes_to_page_split_ls1_a2_q[4:3]};  
      default: lanes_to_page_split_ls1_a2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls1_element_size_a2[1:0])) === 1'bx)
      lanes_to_page_split_ls1_a2[4:0] = {5{1'bx}};
`endif
  end



  always_comb 
  begin: u_total_size_decoded_ls1_a1_5_0
    casez(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_decoded_ls1_a1[5:0] = 6'h01;  
      `RV_BC_SIZE_H: total_size_decoded_ls1_a1[5:0] = 6'h02;  
      `RV_BC_SIZE_W: total_size_decoded_ls1_a1[5:0] = 6'h04;  
      `RV_BC_SIZE_D: total_size_decoded_ls1_a1[5:0] = 6'h08;  
      `RV_BC_SIZE_16: total_size_decoded_ls1_a1[5:0] = 6'h10;  
      `RV_BC_SIZE_32: total_size_decoded_ls1_a1[5:0] = 6'h20;  
      default: total_size_decoded_ls1_a1[5:0] = {6{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_decoded_ls1_a1[5:0] = {6{1'bx}};
`endif
  end





  

   assign ls1_parsed_pred_adjusted_a1[31:0] = ls1_page_split2_a1_q ?  ls1_parsed_pred_a1[31:0] >> bytes_to_page_split_ls1_a2_q[4:0]
                                                                       :  ls1_parsed_pred_a1[31:0]; 

   assign ls1_parsed_pred_adjusted_masked_a1[31:0] = ls1_parsed_pred_adjusted_a1[31:0] &  byte_access_map_pre_ls1_a1[31:0];

   assign first_vld_lane_found_ls1_a1 =  |ls1_parsed_pred_adjusted_masked_a1[31:0]; 

  always_comb 
  begin : first_active_byte_ls1
    integer i;
    first_active_byte_found_ls1_a1 = 1'b0;
    first_active_byte_ls1_a1[4:0] = 5'b0;
    for (i=0; i<32; i=i+1)
    begin : first_active_byte_loop_ls1
     if (ls1_parsed_pred_adjusted_a1[i] & ~first_active_byte_found_ls1_a1) 
     begin : first_active_byte_if_ls1_a1
      first_active_byte_found_ls1_a1 = 1'b1;
      first_active_byte_ls1_a1[4:0] = i;
     end
    end
  end


  always_ff @(posedge clk)
  begin: u_first_active_byte_pre_ls1_a1_4_0
    if (valid_xlat_uop_ls1_a1 == 1'b1)
      first_active_byte_pre_ls1_a1[4:0] <= `RV_BC_DFF_DELAY first_active_byte_ls1_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (valid_xlat_uop_ls1_a1 == 1'b0)
    begin
    end
    else
      first_active_byte_pre_ls1_a1[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign first_active_byte_ls1_a2[4:0] =   {5{ls1_srcpg_v_a2_q & ~(ld_val_ls1_a2_q & ls1_rep_ld_a2_q)}}
                                           & first_active_byte_pre_ls1_a1[4:0];


   assign byte_access_map_ls1_a1[31:0] =   
                                              ls1_ldg_ld_a1 ? 32'h0000_ffff :                                             
                                              byte_access_map_pre_ls1_a1[31:0]
                                           & (    {32{   ~ls1_srcpg_v_a1_q                         
                                                        | ld_val_ls1_a1 & ls1_rep_ld_a1          
                                                  }}
                                               |  ls1_parsed_pred_adjusted_a1[31:0]              
                                             )
                                          ;


  assign  bytes_to_page_split_ls1_a1[4:0] = bytes_to_cache_split_ls1_a1[4:0];




  assign {unused_bytes_ls1_a2[1:0], bytes_to_cache_split_ls1_a1[4:0]} = 7'h40 - {1'b0, ls1_cache_split2_a1_q ? va_ls1_a2_q[5:0] : ls1_fast_va_a1[5:0]};

   assign ls1_parsed_pred_split_adjusted_a1[31:0] = ls1_cache_split2_a1_q ?  ls1_parsed_pred_a1[31:0] >> bytes_to_cache_split_ls1_a1[4:0]
                                                                              :  ls1_parsed_pred_a1[31:0]; 

  assign ls1_split_adjusted_access_size_a1[5:0] = ls1_cache_split1_val_a1 ? {1'b0,bytes_to_cache_split_ls1_a1[4:0]}
                                                                              : total_size_decoded_ls1_a1[5:0] - ({1'b0,bytes_to_cache_split_ls1_a1[4:0]} & {6{ls1_cache_split2_a1_q}});


    assign byte_access_map_split_adjusted_ls1_a1[0] = ls1_split_adjusted_access_size_a1[5:0] > 6'd0;
    assign byte_access_map_split_adjusted_ls1_a1[1] = ls1_split_adjusted_access_size_a1[5:0] > 6'd1;
    assign byte_access_map_split_adjusted_ls1_a1[2] = ls1_split_adjusted_access_size_a1[5:0] > 6'd2;
    assign byte_access_map_split_adjusted_ls1_a1[3] = ls1_split_adjusted_access_size_a1[5:0] > 6'd3;
    assign byte_access_map_split_adjusted_ls1_a1[4] = ls1_split_adjusted_access_size_a1[5:0] > 6'd4;
    assign byte_access_map_split_adjusted_ls1_a1[5] = ls1_split_adjusted_access_size_a1[5:0] > 6'd5;
    assign byte_access_map_split_adjusted_ls1_a1[6] = ls1_split_adjusted_access_size_a1[5:0] > 6'd6;
    assign byte_access_map_split_adjusted_ls1_a1[7] = ls1_split_adjusted_access_size_a1[5:0] > 6'd7;
    assign byte_access_map_split_adjusted_ls1_a1[8] = ls1_split_adjusted_access_size_a1[5:0] > 6'd8;
    assign byte_access_map_split_adjusted_ls1_a1[9] = ls1_split_adjusted_access_size_a1[5:0] > 6'd9;
    assign byte_access_map_split_adjusted_ls1_a1[10] = ls1_split_adjusted_access_size_a1[5:0] > 6'd10;
    assign byte_access_map_split_adjusted_ls1_a1[11] = ls1_split_adjusted_access_size_a1[5:0] > 6'd11;
    assign byte_access_map_split_adjusted_ls1_a1[12] = ls1_split_adjusted_access_size_a1[5:0] > 6'd12;
    assign byte_access_map_split_adjusted_ls1_a1[13] = ls1_split_adjusted_access_size_a1[5:0] > 6'd13;
    assign byte_access_map_split_adjusted_ls1_a1[14] = ls1_split_adjusted_access_size_a1[5:0] > 6'd14;
    assign byte_access_map_split_adjusted_ls1_a1[15] = ls1_split_adjusted_access_size_a1[5:0] > 6'd15;
    assign byte_access_map_split_adjusted_ls1_a1[16] = ls1_split_adjusted_access_size_a1[5:0] > 6'd16;
    assign byte_access_map_split_adjusted_ls1_a1[17] = ls1_split_adjusted_access_size_a1[5:0] > 6'd17;
    assign byte_access_map_split_adjusted_ls1_a1[18] = ls1_split_adjusted_access_size_a1[5:0] > 6'd18;
    assign byte_access_map_split_adjusted_ls1_a1[19] = ls1_split_adjusted_access_size_a1[5:0] > 6'd19;
    assign byte_access_map_split_adjusted_ls1_a1[20] = ls1_split_adjusted_access_size_a1[5:0] > 6'd20;
    assign byte_access_map_split_adjusted_ls1_a1[21] = ls1_split_adjusted_access_size_a1[5:0] > 6'd21;
    assign byte_access_map_split_adjusted_ls1_a1[22] = ls1_split_adjusted_access_size_a1[5:0] > 6'd22;
    assign byte_access_map_split_adjusted_ls1_a1[23] = ls1_split_adjusted_access_size_a1[5:0] > 6'd23;
    assign byte_access_map_split_adjusted_ls1_a1[24] = ls1_split_adjusted_access_size_a1[5:0] > 6'd24;
    assign byte_access_map_split_adjusted_ls1_a1[25] = ls1_split_adjusted_access_size_a1[5:0] > 6'd25;
    assign byte_access_map_split_adjusted_ls1_a1[26] = ls1_split_adjusted_access_size_a1[5:0] > 6'd26;
    assign byte_access_map_split_adjusted_ls1_a1[27] = ls1_split_adjusted_access_size_a1[5:0] > 6'd27;
    assign byte_access_map_split_adjusted_ls1_a1[28] = ls1_split_adjusted_access_size_a1[5:0] > 6'd28;
    assign byte_access_map_split_adjusted_ls1_a1[29] = ls1_split_adjusted_access_size_a1[5:0] > 6'd29;
    assign byte_access_map_split_adjusted_ls1_a1[30] = ls1_split_adjusted_access_size_a1[5:0] > 6'd30;
    assign byte_access_map_split_adjusted_ls1_a1[31] = ls1_split_adjusted_access_size_a1[5:0] > 6'd31;

   assign ls1_parsed_pred_split_adjusted_masked_a1[31:0] = ls1_parsed_pred_split_adjusted_a1[31:0] &  byte_access_map_split_adjusted_ls1_a1[31:0];

   assign vld_split_lane_found_ls1_a1 = ~ls1_srcpg_v_a1_q | (ls1_rep_ld_a1 ? ~ls1_rep_pred_zero_a1 : (|ls1_parsed_pred_split_adjusted_masked_a1[31:0]));
  
   assign ls1_lo_pred_non_zero_a1 = (|(ls1_parsed_pred_a1[15:0] & ls1_pred_mask[15:0]));
   assign ls1_hi_pred_non_zero_a1 = (|(ls1_parsed_pred_a1[31:16] & ls1_pred_mask[15:0]));


   assign ls1_lo_pred_zero_a1 = ~ls1_lo_pred_non_zero_a1;
   assign ls1_hi_pred_zero_a1 = ~ls1_hi_pred_non_zero_a1;

   assign ls1_rep_ld_a1 = (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R);

   assign ls1_qrep_ld_a1 = ( ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ);

   assign ls1_rep_pred_zero_a1 = ~(|ls1_srcpg_data_a1[31:0]);




  
   assign ls1_spe_zero_pg_rep_qrep =   ls1_qrep_ld_a1                   ? ~(|ls1_parsed_pred_adjusted_masked_a1[15:0]):
                                       (~ls_sve_vl_256_q & ls1_rep_ld_a1) ? ~(|ls1_srcpg_data_pq_a1[15:0]) :
                                       ( ls_sve_vl_256_q & ls1_rep_ld_a1) ? ~(|ls1_srcpg_data_pq_a1[31:0]) :
                                                                                1'b0;
   assign ls1_spe_zero_pg_non_qrep =   ls_sve_vl_256_q ? ~(|ls1_parsed_pred_adjusted_masked_a1[31:0]) :
                                                           ~(|ls1_parsed_pred_adjusted_masked_a1[15:0]);

   assign ls1_spe_part_pg_non_qrep = ls_sve_vl_256_q ? |(~ls1_parsed_pred_adjusted_a1[31:0] & byte_access_map_pre_ls1_a1[31:0]) :
                                                         |(~ls1_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls1_a1[15:0]);

   assign ls1_spe_part_pg_uop_qrep = |(~ls1_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls1_a1[15:0]);
  
   assign ls1_spe_part_pg_rep_qrep =    ls1_qrep_ld_a1                    ?   ls1_spe_part_pg_uop_qrep     :
                                        (~ls_sve_vl_256_q & ls1_rep_ld_a1)  ? ~(&ls1_srcpg_data_pq_a1[15:0]) :
                                        ( ls_sve_vl_256_q & ls1_rep_ld_a1)  ? ~(&ls1_srcpg_data_pq_a1[31:0]) :
                                                                                  1'b0 ;

   assign ls1_spe_part_pg_uop     = (ls1_qrep_ld_a1 | ls1_rep_ld_a1) ? ls1_spe_part_pg_rep_qrep : ls1_spe_part_pg_non_qrep;
   assign ls1_spe_zero_pg_uop     = (ls1_qrep_ld_a1 | ls1_rep_ld_a1) ? ls1_spe_zero_pg_rep_qrep : ls1_spe_zero_pg_non_qrep;
   assign ls1_empty_predicate     = ls1_spe_zero_pg_uop & ls1_srcpg_v_a1_q;
   assign ls1_partial_predicate   = ls1_spe_part_pg_uop & ls1_srcpg_v_a1_q;
   

   assign ls1_pred_all_inv_a1 = ls1_srcpg_v_a1_q & (ls1_lo_pred_zero_a1 &  ( ( ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_T_SIZE] != `RV_BC_SIZE_32 ) | ls1_hi_pred_zero_a1)); 

   

   assign ls1_ccpass_st_mod_a1 =    ccpass_ls1_a1
                                   & ( ~ls1_pred_all_inv_a1
                                      | ls1_sp_align_flt_a1              
                                      | ls1_page_split2_a1_q 
                                        & ls1_sp_align_flt_a2_q)         
                                 ;
                                     

  always_ff @(posedge clk)
  begin: u_ls1_ccpass_st_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_ccpass_st_a2_q <= `RV_BC_DFF_DELAY ls1_ccpass_st_mod_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_ccpass_st_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


   assign ls1_pred_inv_force_ccfail_a1 =   ls1_srcpg_v_a1_q 
                                          & ( ls1_rep_ld_a1 ? ls1_rep_pred_zero_a1 
                                                              : (  ~first_vld_lane_found_ls1_a1 
                                                                  & ~(ls1_page_split1_early_val_a1 & prevent_unalign_ls1_a1) 
                                                                )
                                            )
                                          & ~ls1_sp_align_flt_a1 ;              
                                           




 assign ls1_srcpg_data_pq_a1[31:0] = ls1_valid_multi_reg_ld_st_op_a1 ? ls1_ld_st_multi_reg_parsed_pred_a1[31:0] : 
                                       ls1_qrep_ld_a1 ? {16'h0000, ls1_srcpg_data_a1[15:0]} : 
                                                                     ls1_srcpg_data_a1[31:0];

 

  always_ff @(posedge clk)
  begin: u_ls1_srcpg_data_a2_q_31_0
    if (ls1_srcpg_v_a1_q == 1'b1)
      ls1_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY ls1_srcpg_data_pq_a1[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls1_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls1_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls1_ln_size_a2_q_1_0
    if (ls1_srcpg_v_a1_q == 1'b1)
      ls1_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY ls1_ln_size_a1_q[1:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls1_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls1_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`endif
  end


 





  always_comb 
  begin: u_contiguous_lane_vlds_ls1_a1_31_0
    casez(ls1_ln_size_a1_q[1:0])
      2'b00: contiguous_lane_vlds_ls1_a1[31:0] = ls1_srcpg_data_a1_q[31:0];  
      2'b01: contiguous_lane_vlds_ls1_a1[31:0] = {16'b0, ls1_srcpg_data_a1_q[30], ls1_srcpg_data_a1_q[28], ls1_srcpg_data_a1_q[26], ls1_srcpg_data_a1_q[24], ls1_srcpg_data_a1_q[22], ls1_srcpg_data_a1_q[20], ls1_srcpg_data_a1_q[18], ls1_srcpg_data_a1_q[16], ls1_srcpg_data_a1_q[14], ls1_srcpg_data_a1_q[12], ls1_srcpg_data_a1_q[10], ls1_srcpg_data_a1_q[8], ls1_srcpg_data_a1_q[6], ls1_srcpg_data_a1_q[4], ls1_srcpg_data_a1_q[2], ls1_srcpg_data_a1_q[0]};  
      2'b10: contiguous_lane_vlds_ls1_a1[31:0] = {24'b0, ls1_srcpg_data_a1_q[28], ls1_srcpg_data_a1_q[24], ls1_srcpg_data_a1_q[20], ls1_srcpg_data_a1_q[16], ls1_srcpg_data_a1_q[12], ls1_srcpg_data_a1_q[8], ls1_srcpg_data_a1_q[4], ls1_srcpg_data_a1_q[0]};  
      2'b11: contiguous_lane_vlds_ls1_a1[31:0] = {28'b0, ls1_srcpg_data_a1_q[24], ls1_srcpg_data_a1_q[16], ls1_srcpg_data_a1_q[8], ls1_srcpg_data_a1_q[0]};  
      default: contiguous_lane_vlds_ls1_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls1_ln_size_a1_q[1:0])) === 1'bx)
      contiguous_lane_vlds_ls1_a1[31:0] = {32{1'bx}};
`endif
  end


  always_comb 
  begin : find_raw_pred_first_active_lane_ls1_a1
    integer i;
    raw_pred_first_vld_lane_found_ls1_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_first_active_lane_loop_ls1_a1
     raw_pred_first_active_lane_dec_ls1_a1[i] = ~raw_pred_first_vld_lane_found_ls1_a1 & contiguous_lane_vlds_ls1_a1[i] ;
     if (contiguous_lane_vlds_ls1_a1[i])
     begin : find_raw_pred_first_active_lane_if_ls1_a1
      raw_pred_first_vld_lane_found_ls1_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_first_active_lane_ls1_a1_4_0
    raw_pred_first_active_lane_ls1_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_first_active_lane_dec_ls1_a1[macro_i])
        raw_pred_first_active_lane_ls1_a1[4:0] = raw_pred_first_active_lane_ls1_a1[4:0] | macro_i[4:0];
  end


  always_comb 
  begin : find_raw_pred_second_active_lane_ls1_a1
    integer i;
    raw_pred_first_vld_lane_found_2_ls1_a1 = 1'b0;
    raw_pred_second_vld_lane_found_ls1_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_second_active_lane_loop_ls1_a1
     raw_pred_second_lane_dec_ls1_a1[i] = ~(raw_pred_first_vld_lane_found_2_ls1_a1 & raw_pred_second_vld_lane_found_ls1_a1) & raw_pred_first_vld_lane_found_2_ls1_a1 & contiguous_lane_vlds_ls1_a1[i]  ;
     if (contiguous_lane_vlds_ls1_a1[i])
     begin : find_raw_pred_second_active_lane_if_1_ls1_a1
      if (raw_pred_first_vld_lane_found_2_ls1_a1)
      begin:  find_raw_pred_second_active_lane_if_2_ls1_a1
       raw_pred_second_vld_lane_found_ls1_a1= 1'b1;
      end
      raw_pred_first_vld_lane_found_2_ls1_a1= 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_second_lane_ls1_a1_4_0
    raw_pred_second_lane_ls1_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_second_lane_dec_ls1_a1[macro_i])
        raw_pred_second_lane_ls1_a1[4:0] = raw_pred_second_lane_ls1_a1[4:0] | macro_i[4:0];
  end


  assign ff_ld_ls1_a1 = ff_cont_ld_ls1_a1 | ff_gather_ld_ls1_a1;
  assign unalign_ls1_a1_a2 = unalign1_ls1_a1 | unalign2_ls1_a1_q ; 
  assign page_split_ls1_a1_a2 = ls1_page_split1_val_a1 | ls1_ld_page_split2_a1; 

  assign chk_bit_ff_ld_ffr_upd_poss_ls1_a1 = ld_val_ls1_a1 & (   ff_cont_ld_ls1_a1 & raw_pred_second_vld_lane_found_ls1_a1
                                                                   | ff_gather_ld_ls1_a1 & ~scatter_gather_cur_lane_eq_first_active_lane_ls1_a1
                                                                 ) ;

  assign chk_bit_nf_ld_ffr_upd_poss_ls1_a1 = ld_val_ls1_a1 & nf_ld_ls1_a1 & raw_pred_first_vld_lane_found_ls1_a1;

  assign chk_bit_ffr_upd_ls1_a1 =    (ls_ff_nf_ld_ffr_upd_always | ls_ff_nf_ld_ffr_cons_upd_on_exptn) & (chk_bit_ff_ld_ffr_upd_poss_ls1_a1 | chk_bit_nf_ld_ffr_upd_poss_ls1_a1)
                                     | ls_unalign_ff_ld_ffr_cons_upd_on_exptn     & chk_bit_ff_ld_ffr_upd_poss_ls1_a1 & unalign_ls1_a1_a2
                                     | ls_unalign_nf_ld_ffr_cons_upd_on_exptn     & chk_bit_nf_ld_ffr_upd_poss_ls1_a1 & unalign_ls1_a1_a2 
                                     | ls_page_split_ff_ld_ffr_cons_upd_on_exptn  & chk_bit_ff_ld_ffr_upd_poss_ls1_a1 & page_split_ls1_a1_a2
                                     | ls_page_split_nf_ld_ffr_cons_upd_on_exptn  & chk_bit_nf_ld_ffr_upd_poss_ls1_a1 & page_split_ls1_a1_a2; 

  assign chk_bit_ffr_lane_ls1_a1[4:0] =   ( {5{ff_cont_ld_ls1_a1}}           & raw_pred_second_lane_ls1_a1[4:0])
                                          | ( {5{nf_ld_ls1_a1}}                & raw_pred_first_active_lane_ls1_a1[4:0])
                                          | ( {5{not_nf_or_ff_cont_ld_ls1_a1}} & {2'b0, ls1_scatter_gather_ln_num_a1_q[2:0]});  


  always_ff @(posedge clk)
  begin: u_chk_bit_ffr_upd_ls1_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b1)
      chk_bit_ffr_upd_ls1_a2_q <= `RV_BC_DFF_DELAY chk_bit_ffr_upd_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_upd_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


 assign chk_bit_ffr_upd_clk_en_ls1_a1 =      ff_or_nf_ld_a2_flops_clk_en_ls1_a1 
                                             | ls_ff_nf_ld_ffr_upd_always 
                                             | ls_ff_nf_ld_ffr_cons_upd_on_exptn
                                             | ls_unalign_ff_ld_ffr_cons_upd_on_exptn    
                                             | ls_unalign_nf_ld_ffr_cons_upd_on_exptn    
                                             | ls_page_split_ff_ld_ffr_cons_upd_on_exptn 
                                             | ls_page_split_nf_ld_ffr_cons_upd_on_exptn;  
 

  always_ff @(posedge clk_agu1)
  begin: u_chk_bit_ffr_lane_ls1_a2_q_4_0
    if (chk_bit_ffr_upd_clk_en_ls1_a1 == 1'b1)
      chk_bit_ffr_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY chk_bit_ffr_lane_ls1_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (chk_bit_ffr_upd_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_comb 
  begin : find_page_split_lane_mask_ls1
    integer i;
    first_one_found_ls1_a2 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : page_split_lane_mask_loop_ls1
     if (lanes_to_page_split_ls1_a2[4:0] == i)
      first_one_found_ls1_a2 = 1'b1;
      page_split_lane_mask_ls1_a2[i] = first_one_found_ls1_a2;
    end
  end



   assign ffr_vlds_ls1_a1[31:0] =   (   {32{~ls1_page_split2_a1_q | not_nf_or_ff_cont_ld_ls1_a1}}                                                                                                                                | {{32{ls1_page_split2_a1_q}}    &  page_split_lane_mask_ls1_a2[31:0]}                                                    
                                      )
                                    &  contiguous_lane_vlds_ls1_a1[31:0]; 

  always_comb 
  begin : find_ffr_lane_ls1_a1
    integer i;
    vld_lane_found_ls1_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : ffr_lane_loop_ls1
     cont_ld_ffr_lane_dec_ls1_a1[i] = ~vld_lane_found_ls1_a1 & ffr_vlds_ls1_a1[i] ;
     if (ffr_vlds_ls1_a1[i])
     begin : first_vld_lane_found_if_ls1_a1
      vld_lane_found_ls1_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin : find_last_lane_ls1_a1
    integer i;
    vld_last_lane_found_ls1_a1 = 1'b0;
    for (i=31; i>=0; i=i-1)
    begin : last_lane_loop_ls1
     cont_ld_last_lane_dec_ls1_a1[i] = ~vld_last_lane_found_ls1_a1 & ffr_vlds_ls1_a1[i] ;
     if (ffr_vlds_ls1_a1[i])
     begin : first_vld_lane_found_if_ls1_a1
      vld_last_lane_found_ls1_a1 = 1'b1;
     end
    end
  end


  


  assign more_than_one_active_lane_pre_ls1_a1 = (cont_ld_ffr_lane_dec_ls1_a1[31:0] != cont_ld_last_lane_dec_ls1_a1[31:0]);


  always_ff @(posedge clk)
  begin: u_more_than_one_active_lane_pre_ls1_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b1)
      more_than_one_active_lane_pre_ls1_a2_q <= `RV_BC_DFF_DELAY more_than_one_active_lane_pre_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      more_than_one_active_lane_pre_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign more_than_one_active_lane_ls1_a2 =   ls1_page_split2_a1_q  & page_split1_more_than_one_active_lane_ls1_a2 
                                              | ls1_page_split2_a2_q  & first_vld_lane_found_ls1_a3_q
                                              | ~ls1_page_split2_a1_q & more_than_one_active_lane_pre_ls1_a2_q;


  assign page_split1_more_than_one_active_lane_ls1_a2 = (cont_ld_ffr_lane_ls1_a1[4:0] != raw_pred_second_lane_ls1_a2_q[4:0]) & ~(mid_first_lane_page_split_ls1_a2 & (|(ffr_vlds_ls1_a1[31:0]))) ;

  assign mid_first_lane_page_split_ls1_a2 = (ffr_lane_ls1_a2_q[4:0] == cont_ld_ffr_lane_ls1_a1[4:0]);



  always_comb 
  begin: u_cont_ld_ffr_lane_ls1_a1_4_0
    cont_ld_ffr_lane_ls1_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (cont_ld_ffr_lane_dec_ls1_a1[macro_i])
        cont_ld_ffr_lane_ls1_a1[4:0] = cont_ld_ffr_lane_ls1_a1[4:0] | macro_i[4:0];
  end





  assign ff_or_nf_ld_a2_flops_clk_en_ls1_a1 = (ff_cont_ld_ls1_a1 | ff_gather_ld_ls1_a1 | nf_ld_ls1_a1) & ld_val_ls1_a1; 


  always_ff @(posedge clk)
  begin: u_raw_pred_second_lane_ls1_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b1)
      raw_pred_second_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY raw_pred_second_lane_ls1_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      raw_pred_second_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign cont_ld_second_ffr_lane_ls1_a2[4:0] = ls1_page_split2_a2_q & first_vld_lane_found_ls1_a3_q & ~mid_first_lane_page_split_ls1_a3_q ? ffr_lane_ls1_a2_q[4:0]
                                                                                                                                                  : raw_pred_second_lane_ls1_a2_q[4:0];

  assign ffr_lane_ls1_a1[4:0] =  ( {5{~not_nf_or_ff_cont_ld_ls1_a1}} &  cont_ld_ffr_lane_ls1_a1[4:0])                   
                                 | ( {5{ ff_gather_ld_ls1_a1}}         & {2'b0, ls1_scatter_gather_ln_num_a1_q[2:0]}) ;   


  always_ff @(posedge clk)
  begin: u_ffr_lane_ls1_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b1)
      ffr_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY ffr_lane_ls1_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      ffr_lane_ls1_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_ff_cont_ld_ls1_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      ff_cont_ld_ls1_a2_q <= `RV_BC_DFF_DELAY ff_cont_ld_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ff_cont_ld_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_cont_ld_ls1_a2 = ld_val_ls1_a2_q & ff_cont_ld_ls1_a2_q;


  always_ff @(posedge clk)
  begin: u_nf_ld_ls1_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      nf_ld_ls1_a2_q <= `RV_BC_DFF_DELAY nf_ld_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      nf_ld_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign nf_ld_ls1_a2 = ld_val_ls1_a2_q & nf_ld_ls1_a2_q;


  always_ff @(posedge clk)
  begin: u_ff_gather_ld_ls1_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      ff_gather_ld_ls1_a2_q <= `RV_BC_DFF_DELAY ff_gather_ld_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ff_gather_ld_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls1_rep_ld_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      ls1_rep_ld_a2_q <= `RV_BC_DFF_DELAY ls1_rep_ld_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ls1_rep_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_gather_ld_ls1_a2 = ld_val_ls1_a2_q & ff_gather_ld_ls1_a2_q;

  assign ff_ld_ls1_a2 = ff_cont_ld_ls1_a2 | ff_gather_ld_ls1_a2;

  assign ff_or_nf_ld_ls1_a2 = ff_ld_ls1_a2 | nf_ld_ls1_a2 ;


  assign scatter_gather_cur_lane_eq_first_active_lane_ls1_a1 =    (ls1_scatter_gather_ln_num_a1_q[2:0] == cont_ld_ffr_lane_ls1_a1[2:0]);



  always_ff @(posedge clk)
  begin: u_scatter_gather_cur_lane_eq_first_active_lane_ls1_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b1)
      scatter_gather_cur_lane_eq_first_active_lane_ls1_a2_q <= `RV_BC_DFF_DELAY scatter_gather_cur_lane_eq_first_active_lane_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a1 == 1'b0)
    begin
    end
    else
      scatter_gather_cur_lane_eq_first_active_lane_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls1_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      first_vld_lane_found_ls1_a2_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls1_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_or_nf_ld_a2_flops_clk_en_ls1_a2 = ff_or_nf_ld_ls1_a2 & ld_val_ls1_a2_q; 


  always_ff @(posedge clk)
  begin: u_ffr_lane_eq_first_active_lane_ls1_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b1)
      ffr_lane_eq_first_active_lane_ls1_a3_q <= `RV_BC_DFF_DELAY ffr_lane_eq_first_active_lane_ls1_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b0)
    begin
    end
    else
      ffr_lane_eq_first_active_lane_ls1_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end





  always_ff @(posedge clk)
  begin: u_mid_first_lane_page_split_ls1_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b1)
      mid_first_lane_page_split_ls1_a3_q <= `RV_BC_DFF_DELAY mid_first_lane_page_split_ls1_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b0)
    begin
    end
    else
      mid_first_lane_page_split_ls1_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls1_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b1)
      first_vld_lane_found_ls1_a3_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls1_a2_q;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls1_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls1_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ffr_lane_eq_first_active_lane_ls1_a2 =   ls1_sp_align_flt_a2_q                                                                                      
                                                  | ( not_nf_or_ff_cont_ld_ls1_a2              ? scatter_gather_cur_lane_eq_first_active_lane_ls1_a2_q :
                                                      ld_val_ls1_a2_q & ls1_page_split2_a2_q ?  (  ~ffr_lane_eq_first_active_lane_ls1_a3_q                 
 
                                                                                                      | mid_first_lane_page_split_ls1_a3_q                     
                                                                                                    ) &  first_vld_lane_found_ls1_a2_q   
                                                                                                 : first_vld_lane_found_ls1_a2_q
                                                    );  




  assign first_vld_lane_found_ls1_a2 =    first_vld_lane_found_ls1_a2_q
                                         |  ld_val_ls1_a2_q & ls1_rep_ld_a2_q            
                                         | ~ls1_srcpg_v_a2_q                               
                                         |  ls1_sp_align_flt_a2_q;                         





  assign ls1_ld_reject_gather_nxt_i2 = ls1_ld_reject_gather_i2 & issue_v_ls1_i2;

  rv_bc_dffr #(.W(1)) u_unalign2_ls1_a1_0 (.q(unalign2_ls1_a1_q),                            .din(unalign2_ls1_i2),                             .clk(clk), .en(any_issue_v_ls1_i2_a2), .reset(reset_i));
  rv_bc_dffr #(.W(1)) u_unalign2_ls1_a1_1 (.q(unalign2_dup_ls1_a1_q),                        .din(unalign2_ls1_i2),                             .clk(clk), .en(any_issue_v_ls1_i2_a2), .reset(reset_i));

  always_ff @(posedge clk or posedge reset_i)
  begin: u_unalign2_ls1_a2_q
    if (reset_i == 1'b1)
      unalign2_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      unalign2_ls1_a2_q <= `RV_BC_DFF_DELAY unalign2_ls1_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      unalign2_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      unalign2_ls1_a2_q <= `RV_BC_DFF_DELAY unalign2_ls1_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_page_split2_a1_q
    if (reset_i == 1'b1)
      ls1_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_page_split2_a1_q <= `RV_BC_DFF_DELAY ls1_page_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_page_split2_a1_q <= `RV_BC_DFF_DELAY ls1_page_split1_val_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_page_split2_a2_q
    if (reset_i == 1'b1)
      ls1_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_page_split2_a2_q <= `RV_BC_DFF_DELAY ls1_page_split2_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_page_split2_a2_q <= `RV_BC_DFF_DELAY ls1_page_split2_a1_q;
`endif
  end


  assign ls1_a1_reject_i2 =    ls1_ld_reject_gather_nxt_i2
                              |   ls_ff_nf_ld_ffr_upd_always & issue_ld_val_ls1_i2                                                             
                                & (   (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_CONT_FF_LD) 
                                    | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_FF_LD) 
                                    | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD) 
                                  )
                                & ~ls1_precommit_uop_i2_unqual
                                & ~address_inject_val_ls1_i2_q;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_a1_reject_a1_q
    if (reset_i == 1'b1)
      ls1_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls1_a1_reject_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls1_a1_reject_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls1_i2_q
    if (reset_i == 1'b1)
      address_inject_val_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls1_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_i1;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls1_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_i1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls1_a1_q
    if (reset_i == 1'b1)
      address_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_i2_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_i2_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls1_a2_q
    if (reset_i == 1'b1)
      address_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls1_a1_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls1_a1_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls1_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls1_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls1_a2_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls1_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls1_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls1_a1_q
    if (reset_i == 1'b1)
      spe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls1_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls1_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls1_a2_q
    if (reset_i == 1'b1)
      spe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls1_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls1_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls1_a1_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls1_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls1_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls1_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls1_a2_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls1_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls1_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls1_a1_q;
`endif
  end




  always_ff @(posedge clk)
  begin: u_uid_ls1_i2_q_8_0
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      uid_ls1_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY is_ls_uid_ls1_i1[`RV_BC_UID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      uid_ls1_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY {9{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_rid_ls1_i2_q
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      rid_ls1_i2_q <= `RV_BC_DFF_DELAY is_ls_rid_ls1_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      rid_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



   

  always_ff @(posedge clk)
  begin: u_ls1_stid_i2_q_6_0
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      ls1_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY is_ls_stid_ls1_i1[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      ls1_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resx_ls1_i2_q
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      dep_d4_resx_ls1_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resx_ls1_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resx_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resy_ls1_i2_q
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      dep_d4_resy_ls1_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resy_ls1_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resy_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resz_ls1_i2_q
    if (is_ls_issue_v_ls1_i1 == 1'b1)
      dep_d4_resz_ls1_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resz_ls1_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls1_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resz_ls1_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu1)
  begin: u_stid_ls1_a1_q_6_0
    if (issue_v_poss_ls1_i2 == 1'b1)
      stid_ls1_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY ls1_stid_i2_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      stid_ls1_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_tmp_ls_uop_ctl_ls1_a1_q_21_0
    if (issue_v_poss_ls1_i2 == 1'b1)
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SP_BASE:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY {22{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_tmp_ls_uop_ctl_ls1_a1_q_26
    if (issue_v_poss_ls1_i2 == 1'b1)
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_IL];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_tmp_ls_uop_ctl_ls1_a1_q_27
    if (issue_v_poss_ls1_i2 == 1'b1)
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_HSR_ISS_V];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_tmp_ls_uop_ctl_ls1_a1_q_32_28
    if (issue_v_poss_ls1_i2 == 1'b1)
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_HSR_ISS_RT];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_precommit_uop_a1_q
    if (reset_i == 1'b1)
      ls1_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls1_i2 == 1'b1)
      ls1_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls1_precommit_uop_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      ls1_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls1_i2 == 1'b1)
      ls1_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls1_precommit_uop_i2;
`endif
  end



  always_ff @(posedge clk)
  begin: u_stid_ls1_a2_q_6_0
    if (op_val_ls1_a1 == 1'b1)
      stid_ls1_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY stid_ls1_a1_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (op_val_ls1_a1 == 1'b0)
    begin
    end
    else
      stid_ls1_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] = tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT];
  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_V]  = tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_HSR_ISS_V];
  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_IL]         = tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_IL];
  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SP_BASE:0]  = tmp_ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SP_BASE:0];
  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SRCB_EXT]   = 2'b00; 
  assign ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SRCB_SH]    = 2'b00; 

  assign ls1_sp_base_a1            = ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_SP_BASE]; 

  assign ls1_ld_unalign1_a2        =  (ld_val_ls1_a2_q & unalign2_ls1_a1_q);
  assign ls1_ld_page_split1_a2     =  (ld_val_ls1_a2_q & ls1_page_split2_a1_q);
  assign ls1_st_page_split1_a2     =  (st_val_ls1_a2_q & ls1_page_split2_a1_q);

  assign ls1_ld_unalign2_a1        =  (ld_val_ls1_a2_q & unalign2_ls1_a1_q);
  assign ls1_ld_page_split2_a1     =  (ld_val_ls1_a2_q & ls1_page_split2_a1_q);


  assign pf_tlb_inject_v_ls1_i2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls1_i2_q & ~tmo_inject_val_ls1_i2   & ~spe_inject_val_ls1_i2 & ~tbe_inject_val_ls1_i2;
  assign pf_tlb_inject_v_ls1_a1    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls1_a1_q & ~tmo_inject_val_ls1_a1_q & ~spe_inject_val_ls1_a1_q & ~tbe_inject_val_ls1_a1_q;
  assign pf_tlb_inject_v_ls1_a2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls1_a2_q & ~tmo_inject_val_ls1_a2_q & ~spe_inject_val_ls1_a2_q & ~tbe_inject_val_ls1_a2_q;

  assign ls_is_uop_reject_ls1_d1   =  ls1_a1_reject_a1_q;

  assign any_issue_v_ls1_i2_a2 =  issue_v_ls1_i2_q
                                 | issue_ld_val_ls1_a1_q | issue_st_val_ls1_a1_q 
                                 |       ld_val_ls1_a2_q |       st_val_ls1_a2_q  
                                 | ls1_st_pf_on_rst_full_a1_q;


  assign issue_v_ls2_i1 = is_ls_issue_v_ls2_i1   & ~is_ls_issue_cancel_ls2_i1;

  rv_bc_flush_compare   u_ls2_uop_flush_i2 (
      .flush_match (ls2_uop_flush_i2),
      .flush       (flush),
      .flush_uid   (flush_uid[`RV_BC_UID]), 
      .uop_uid     (uid_ls2_i2_q[`RV_BC_UID]) 
    );




assign issue_v_ls2_i2 =       issue_v_ls2_i2_q & ~is_ls_issue_cancel_ls2_i2
                                             & (~ls2_uop_flush_i2 | address_inject_val_ls2_i2_q)
                                             & ~unalign2_ls2_i2                  
                                             & (~dep_d4_resx_ls2_i2_q | ~ls_is_resx_cancel_d4 | address_inject_val_ls2_i2_q)
                                             & (~dep_d4_resy_ls2_i2_q | ~ls_is_resy_cancel_d4 | address_inject_val_ls2_i2_q)
                                             & (~dep_d4_resz_ls2_i2_q | ~ls_is_resz_cancel_d4 | address_inject_val_ls2_i2_q);

assign issue_v_early_ls2_i2 =       issue_v_ls2_i2_q & ~is_ls_issue_cancel_ls2_i2
                                             &  ~unalign2_ls2_i2 ;           

assign issue_v_poss_ls2_i2  =       issue_v_ls2_i2_q
                                             &  ~unalign2_ls2_i2 ;

assign issue_cancel_ls2_i2  = ~address_inject_val_ls2_i2_q
                              & ( is_ls_issue_cancel_ls2_i2
                                | dep_d4_resx_ls2_i2_q & ls_is_resx_cancel_d4
                                | dep_d4_resy_ls2_i2_q & ls_is_resy_cancel_d4
                                | dep_d4_resz_ls2_i2_q & ls_is_resz_cancel_d4);

  assign op_val_ls2_a1 = (ld_val_ls2_a1 | st_val_ls2_a1) & ~unalign2_ls2_a1_q;
 
  assign ld_val_ls2_clken_a1 = ld_val_ls2_a1 & ~unalign2_ls2_a1_q;

  assign address_inject_val_ls2_i1 = is_ls_issue_v_ls2_i1 & is_ls_issue_type_ls2_i1 ;
  
  assign tmo_inject_val_ls2_i2 = address_inject_val_ls2_i2_q &  tmo_inject_outstanding_q;
  assign spe_inject_val_ls2_i2 = address_inject_val_ls2_i2_q &  spe_inject_outstanding_q;

  assign tbe_inject_val_ls2_i2 = address_inject_val_ls2_i2_q &  tbe_inject_outstanding_q;

  assign ls2_type_ldg_i2 = (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG);




  assign ld_val_ls2_arb_possible_i2 = (issue_ld_val_ls2_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ~(ls_enable_serialize_gather_q & iq2_gather_ld_i2) & ~ls2_ld_ssbb_blk_i2) | 
                                        (issue_ld_val_ls2_a1_q & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & unalign2_ls2_i2 & ~(ls_enable_serialize_gather_q & iq2_gather_ld_a1_q) & ~ls2_ld_ssbb_blk_a1_q) | 
                                        ( issue_v_ls2_i2 & ~blk_non_oldest_ld_q & ~disable_iq_ld_arb_q & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls2_i2 & rst_full_ls2_q ) ;

  assign ls2_st_pf_on_rst_full_i2 = ( issue_v_ls2_i2 & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls2_i2 & rst_full_ls2_q ) ;
  assign ls2_st_pf_on_rst_full_poss_i2 = ( issue_v_ls2_i2_q & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls2_i2 & rst_full_ls2_q ) ;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_v_ls2_i2_q
    if (reset_i == 1'b1)
      issue_v_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0)
      issue_v_ls2_i2_q <= `RV_BC_DFF_DELAY issue_v_ls2_i1;
    else
      issue_v_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else
      issue_v_ls2_i2_q <= `RV_BC_DFF_DELAY issue_v_ls2_i1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_st_pf_on_rst_full_a1_q
    if (reset_i == 1'b1)
      ls2_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls2_st_pf_on_rst_full_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_st_pf_on_rst_full_a1_q <= `RV_BC_DFF_DELAY ls2_st_pf_on_rst_full_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ld_val_ls2_a1_q
    if (reset_i == 1'b1)
      issue_ld_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      issue_ld_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls2_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ld_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      issue_ld_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_ld_val_ls2_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls2_arb_possible_a1_q
    if (reset_i == 1'b1)
      ld_val_ls2_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ld_val_ls2_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls2_arb_possible_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls2_arb_possible_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ld_val_ls2_arb_possible_a1_q <= `RV_BC_DFF_DELAY ld_val_ls2_arb_possible_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_st_val_ls2_a1_q
    if (reset_i == 1'b1)
      issue_st_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      issue_st_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls2_a1_din;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      issue_st_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      issue_st_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_st_val_ls2_a1_din;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ld_val_ls2_a2_q
    if (reset_i == 1'b1)
      ld_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ld_val_ls2_a2_q <= `RV_BC_DFF_DELAY ld_val_ls2_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ld_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ld_val_ls2_a2_q <= `RV_BC_DFF_DELAY ld_val_ls2_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_st_val_ls2_a2_q
    if (reset_i == 1'b1)
      st_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      st_val_ls2_a2_q <= `RV_BC_DFF_DELAY st_val_ls2_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      st_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      st_val_ls2_a2_q <= `RV_BC_DFF_DELAY st_val_ls2_a1;
`endif
  end



  always_ff @(posedge clk_agu2)
  begin: u_ls2_frc_unchecked_a1_q
    if (issue_v_poss_ls2_i2 == 1'b1)
      ls2_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY is_ls_force_unchecked_ls2_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_frc_unchecked_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu2)
  begin: u_iq2_gather_ld_a1_q
    if (issue_v_poss_ls2_i2 == 1'b1)
      iq2_gather_ld_a1_q <= `RV_BC_DFF_DELAY iq2_gather_ld_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      iq2_gather_ld_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_iq2_gather_ld_a2_q
    if (any_issue_v_ls2_i2_a2 == 1'b1)
      iq2_gather_ld_a2_q <= `RV_BC_DFF_DELAY iq2_gather_ld_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      iq2_gather_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ls2_element_size_a1[2:0] = ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_E_SIZE];

   assign ls2_vl16_a1 = 1'b1;


  assign ls2_ld_unpred_sve_uop_i2 = issue_ld_val_ls2_i2 & ~address_inject_val_ls2_i2_q & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_UNPRED_LD);


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_ls2_ld_unpred_sve_uop_a1_q
    if (reset_i == 1'b1)
      ls2_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls2_i2 == 1'b1)
      ls2_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls2_ld_unpred_sve_uop_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls2_i2 == 1'b1)
      ls2_ld_unpred_sve_uop_a1_q <= `RV_BC_DFF_DELAY ls2_ld_unpred_sve_uop_i2;
`endif
  end


  assign iq2_gather_ld_i2 = ((ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) 
                            |  (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)) & ~address_inject_val_ls2_i2_q;

  assign is_ls_srcpg_v_ls2_qual_i2 = unalign2_ls2_i2 ? ls2_srcpg_v_a1_q : is_ls_srcpg_v_ls2_i2 & issue_v_early_ls2_i2;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_srcpg_v_a1_q
    if (reset_i == 1'b1)
      ls2_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls2_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls2_qual_i2;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls2_srcpg_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls2_srcpg_v_a1_q <= `RV_BC_DFF_DELAY is_ls_srcpg_v_ls2_qual_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_srcpg_v_a2_q
    if (reset_i == 1'b1)
      ls2_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b1)
      ls2_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls2_srcpg_v_a1_q;
    else if (reset_i == 1'b0 && lsx_srcpg_clk_en == 1'b0)
    begin
    end
    else
      ls2_srcpg_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (lsx_srcpg_clk_en == 1'b1)
      ls2_srcpg_v_a2_q <= `RV_BC_DFF_DELAY ls2_srcpg_v_a1_q;
`endif
  end


  assign ls2_srcpg_data_i2[31:0] = {16'h0000, is_ls_srcpg_data_ls2_i2[15:0]};

  assign srcpg_issue_v_ls2_i2 = issue_v_poss_ls2_i2 & is_ls_srcpg_v_ls2_i2;
  

  always_ff @(posedge clk_agu2)
  begin: u_ls2_srcpg_data_a1_q_31_0
    if (srcpg_issue_v_ls2_i2 == 1'b1)
      ls2_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY ls2_srcpg_data_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (srcpg_issue_v_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_srcpg_data_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  assign ls2_scatter_gather_v_i2 = issue_v_ls2_i2_q & ( (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)) |
                                                           (~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ( (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD) | 
                                                                                                           (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD) |
                                                          (((ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD) | 
                                                           ((ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLI_MASK) == `RV_BC_LS_TYPE_PLI)) & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_RES_EXT] 
                                                                                                         ) 
                                                                                                            
                                                            )
                                                          ); 

  assign is_ls_dsty_vlreg_ls2_i2[1:0] =  {is_ls_dsty_vlreg_ls2_i2_q[1] | ls2_scatter_gather_v_i2, is_ls_dsty_vlreg_ls2_i2_q[0]} ;

  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_ls2_ln_size_a1_q_1_0
    if (reset_i == 1'b1)
      ls2_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls2_i2 == 1'b1)
      ls2_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls2_i2[1:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`else
    else if (srcpg_issue_v_ls2_i2 == 1'b1)
      ls2_ln_size_a1_q[1:0] <= `RV_BC_DFF_DELAY is_ls_dsty_vlreg_ls2_i2[1:0];
`endif
  end


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_ls2_scatter_gather_ln_num_a1_q_2_0
    if (reset_i == 1'b1)
      ls2_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcpg_issue_v_ls2_i2 == 1'b1)
      ls2_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls2_i2_q[2:0];
    else if (reset_i == 1'b0 && srcpg_issue_v_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY {3{1'bx}};
`else
    else if (srcpg_issue_v_ls2_i2 == 1'b1)
      ls2_scatter_gather_ln_num_a1_q[2:0] <= `RV_BC_DFF_DELAY is_ls_dstx_vlreg_ls2_i2_q[2:0];
`endif
  end




  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_ls2_scatter_gather_v_a1_q
    if (reset_i == 1'b1)
      ls2_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_early_ls2_i2 == 1'b1)
      ls2_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls2_scatter_gather_v_i2;
    else if (reset_i == 1'b0 && issue_v_early_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_early_ls2_i2 == 1'b1)
      ls2_scatter_gather_v_a1_q <= `RV_BC_DFF_DELAY ls2_scatter_gather_v_i2;
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls2_scatter_gather_v_a2_q
    if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY ls2_scatter_gather_v_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_scatter_gather_v_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end







  always_comb 
  begin: u_ls2_srcpg_data_a1_31_0
    case(ls2_ln_size_a1_q[1:0])
      2'b00: ls2_srcpg_data_a1[31:0] = ls2_srcpg_data_a1_q[31:0];  
      2'b01: ls2_srcpg_data_a1[31:0] = {{2{ls2_srcpg_data_a1_q[30]}}, {2{ls2_srcpg_data_a1_q[28]}}, {2{ls2_srcpg_data_a1_q[26]}}, {2{ls2_srcpg_data_a1_q[24]}}, {2{ls2_srcpg_data_a1_q[22]}}, {2{ls2_srcpg_data_a1_q[20]}}, {2{ls2_srcpg_data_a1_q[18]}}, {2{ls2_srcpg_data_a1_q[16]}}, {2{ls2_srcpg_data_a1_q[14]}}, {2{ls2_srcpg_data_a1_q[12]}}, {2{ls2_srcpg_data_a1_q[10]}}, {2{ls2_srcpg_data_a1_q[8]}}, {2{ls2_srcpg_data_a1_q[6]}}, {2{ls2_srcpg_data_a1_q[4]}}, {2{ls2_srcpg_data_a1_q[2]}}, {2{ls2_srcpg_data_a1_q[0]}}};  
      2'b10: ls2_srcpg_data_a1[31:0] = {{4{ls2_srcpg_data_a1_q[28]}}, {4{ls2_srcpg_data_a1_q[24]}}, {4{ls2_srcpg_data_a1_q[20]}}, {4{ls2_srcpg_data_a1_q[16]}}, {4{ls2_srcpg_data_a1_q[12]}}, {4{ls2_srcpg_data_a1_q[8]}}, {4{ls2_srcpg_data_a1_q[4]}}, {4{ls2_srcpg_data_a1_q[0]}}};  
      2'b11: ls2_srcpg_data_a1[31:0] = {{8{ls2_srcpg_data_a1_q[24]}}, {8{ls2_srcpg_data_a1_q[16]}}, {8{ls2_srcpg_data_a1_q[8]}}, {8{ls2_srcpg_data_a1_q[0]}}};  
      default: ls2_srcpg_data_a1[31:0] = {32{1'bx}};
    endcase
  end




   assign ls2_el_ln_size_b_h_a1 = (ls2_ln_size_a1_q[1:0] == 2'b01) & (ls2_element_size_a1[1:0] == 2'b00) ;
   assign ls2_el_ln_size_b_w_a1 = (ls2_ln_size_a1_q[1:0] == 2'b10) & (ls2_element_size_a1[1:0] == 2'b00) ;
   assign ls2_el_ln_size_b_d_a1 = (ls2_ln_size_a1_q[1:0] == 2'b11) & (ls2_element_size_a1[1:0] == 2'b00) ;
   assign ls2_el_ln_size_h_w_a1 = (ls2_ln_size_a1_q[1:0] == 2'b10) & (ls2_element_size_a1[1:0] == 2'b01) ;
   assign ls2_el_ln_size_h_d_a1 = (ls2_ln_size_a1_q[1:0] == 2'b11) & (ls2_element_size_a1[1:0] == 2'b01) ;
   assign ls2_el_ln_size_w_d_a1 = (ls2_ln_size_a1_q[1:0] == 2'b11) & (ls2_element_size_a1[1:0] == 2'b10) ;
   assign ls2_el_ln_size_eq_a1  = (ls2_ln_size_a1_q[1:0] == ls2_element_size_a1[1:0]) ;


   assign ls2_compact_pred_el_ln_size_b_h_a1[15:0] = {ls2_srcpg_data_a1_q[30], ls2_srcpg_data_a1_q[28], ls2_srcpg_data_a1_q[26], ls2_srcpg_data_a1_q[24], 
                                                  ls2_srcpg_data_a1_q[22], ls2_srcpg_data_a1_q[20], ls2_srcpg_data_a1_q[18], ls2_srcpg_data_a1_q[16],
                                                  ls2_srcpg_data_a1_q[14], ls2_srcpg_data_a1_q[12], ls2_srcpg_data_a1_q[10], ls2_srcpg_data_a1_q[ 8],
                                                  ls2_srcpg_data_a1_q[ 6], ls2_srcpg_data_a1_q[ 4], ls2_srcpg_data_a1_q[ 2], ls2_srcpg_data_a1_q[ 0]}; 

   assign ls2_compact_pred_el_ln_size_b_w_a1[7:0] =  {ls2_srcpg_data_a1_q[28], ls2_srcpg_data_a1_q[24],        
                                                  ls2_srcpg_data_a1_q[20], ls2_srcpg_data_a1_q[16],
                                                  ls2_srcpg_data_a1_q[12], ls2_srcpg_data_a1_q[ 8],
                                                  ls2_srcpg_data_a1_q[ 4], ls2_srcpg_data_a1_q[ 0]};

   assign ls2_compact_pred_el_ln_size_b_d_a1[3:0] =  {ls2_srcpg_data_a1_q[24],
                                                  ls2_srcpg_data_a1_q[16],
                                                  ls2_srcpg_data_a1_q[ 8],
                                                  ls2_srcpg_data_a1_q[ 0]};


   assign ls2_compact_pred_el_ln_size_h_w_a1[15:0] =  {{2{ls2_srcpg_data_a1_q[28]}}, {2{ls2_srcpg_data_a1_q[24]}},        
                                                   {2{ls2_srcpg_data_a1_q[20]}}, {2{ls2_srcpg_data_a1_q[16]}},
                                                   {2{ls2_srcpg_data_a1_q[12]}}, {2{ls2_srcpg_data_a1_q[ 8]}},
                                                   {2{ls2_srcpg_data_a1_q[ 4]}}, {2{ls2_srcpg_data_a1_q[ 0]}}};

   assign ls2_compact_pred_el_ln_size_h_d_a1[7:0] =  {{2{ls2_srcpg_data_a1_q[24]}},
                                                  {2{ls2_srcpg_data_a1_q[16]}},
                                                  {2{ls2_srcpg_data_a1_q[ 8]}},
                                                  {2{ls2_srcpg_data_a1_q[ 0]}}};

   assign ls2_compact_pred_el_ln_size_w_d_a1[15:0] =  {{4{ls2_srcpg_data_a1_q[24]}},
                                                         {4{ls2_srcpg_data_a1_q[16]}},
                                                         {4{ls2_srcpg_data_a1_q[ 8]}},
                                                         {4{ls2_srcpg_data_a1_q[ 0]}}};

 
   assign ls2_ld2_st2_a1 = (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2);
   assign ls2_ld3_st3_a1 = (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3);
   assign ls2_ld4_st4_a1 = (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4);

   assign ls2_uop_num_a1[1:0] = {2{ls2_valid_multi_reg_ld_st_op_a1}} & ls2_scatter_gather_ln_num_a1_q[1:0];  


   assign ls2_ld2_st2_parsed_pred_a1_uop0[31:0] =   {{2{ls2_srcpg_data_a1[15]}}, {2{ls2_srcpg_data_a1[14]}}, {2{ls2_srcpg_data_a1[13]}}, {2{ls2_srcpg_data_a1[12]}}, 
                                                       {2{ls2_srcpg_data_a1[11]}}, {2{ls2_srcpg_data_a1[10]}}, {2{ls2_srcpg_data_a1[ 9]}}, {2{ls2_srcpg_data_a1[ 8]}},
                                                       {2{ls2_srcpg_data_a1[ 7]}}, {2{ls2_srcpg_data_a1[ 6]}}, {2{ls2_srcpg_data_a1[ 5]}}, {2{ls2_srcpg_data_a1[ 4]}},
                                                       {2{ls2_srcpg_data_a1[ 3]}}, {2{ls2_srcpg_data_a1[ 2]}}, {2{ls2_srcpg_data_a1[ 1]}}, {2{ls2_srcpg_data_a1[ 0]}}}; 

   assign ls2_ld2_st2_parsed_pred_a1_uop1[31:0] =   {{2{ls2_srcpg_data_a1[31]}}, {2{ls2_srcpg_data_a1[30]}}, {2{ls2_srcpg_data_a1[29]}}, {2{ls2_srcpg_data_a1[28]}}, 
                                                       {2{ls2_srcpg_data_a1[27]}}, {2{ls2_srcpg_data_a1[26]}}, {2{ls2_srcpg_data_a1[25]}}, {2{ls2_srcpg_data_a1[24]}},
                                                       {2{ls2_srcpg_data_a1[23]}}, {2{ls2_srcpg_data_a1[22]}}, {2{ls2_srcpg_data_a1[21]}}, {2{ls2_srcpg_data_a1[20]}},
                                                       {2{ls2_srcpg_data_a1[19]}}, {2{ls2_srcpg_data_a1[18]}}, {2{ls2_srcpg_data_a1[17]}}, {2{ls2_srcpg_data_a1[16]}}};

 
   assign ls2_ld3_st3_parsed_pred_a1_uop0[31:0] =   {{2{ls2_srcpg_data_a1[10]}}, {3{ls2_srcpg_data_a1[ 9]}}, {3{ls2_srcpg_data_a1[ 8]}},
                                                       {3{ls2_srcpg_data_a1[ 7]}}, {3{ls2_srcpg_data_a1[ 6]}}, {3{ls2_srcpg_data_a1[ 5]}}, {3{ls2_srcpg_data_a1[ 4]}},
                                                       {3{ls2_srcpg_data_a1[ 3]}}, {3{ls2_srcpg_data_a1[ 2]}}, {3{ls2_srcpg_data_a1[ 1]}}, {3{ls2_srcpg_data_a1[ 0]}}}; 

   assign ls2_ld3_st3_parsed_pred_a1_uop1[31:0] =    {{{ls2_srcpg_data_a1[21]}},  {3{ls2_srcpg_data_a1[20]}}, {3{ls2_srcpg_data_a1[19]}}, {3{ls2_srcpg_data_a1[18]}},
                                                        {3{ls2_srcpg_data_a1[17]}}, {3{ls2_srcpg_data_a1[16]}}, {3{ls2_srcpg_data_a1[15]}}, {3{ls2_srcpg_data_a1[14]}},
                                                        {3{ls2_srcpg_data_a1[13]}}, {3{ls2_srcpg_data_a1[12]}}, {3{ls2_srcpg_data_a1[11]}}, { {ls2_srcpg_data_a1[10]}}};
 
   assign ls2_ld3_st3_parsed_pred_a1_uop2[31:0] =    {{3{ls2_srcpg_data_a1[31]}}, {3{ls2_srcpg_data_a1[30]}}, {3{ls2_srcpg_data_a1[29]}},
                                                        {3{ls2_srcpg_data_a1[28]}}, {3{ls2_srcpg_data_a1[27]}}, {3{ls2_srcpg_data_a1[26]}}, {3{ls2_srcpg_data_a1[25]}},
                                                        {3{ls2_srcpg_data_a1[24]}}, {3{ls2_srcpg_data_a1[23]}}, {3{ls2_srcpg_data_a1[22]}}, {2{ls2_srcpg_data_a1[21]}}};
 

   assign ls2_ld4_st4_parsed_pred_a1_uop0[31:0] =   {{4{ls2_srcpg_data_a1[ 7]}}, {4{ls2_srcpg_data_a1[ 6]}}, {4{ls2_srcpg_data_a1[ 5]}}, {4{ls2_srcpg_data_a1[ 4]}},
                                                       {4{ls2_srcpg_data_a1[ 3]}}, {4{ls2_srcpg_data_a1[ 2]}}, {4{ls2_srcpg_data_a1[ 1]}}, {4{ls2_srcpg_data_a1[ 0]}}}; 

   assign ls2_ld4_st4_parsed_pred_a1_uop1[31:0] =   {{4{ls2_srcpg_data_a1[15]}}, {4{ls2_srcpg_data_a1[14]}}, {4{ls2_srcpg_data_a1[13]}}, {4{ls2_srcpg_data_a1[12]}}, 
                                                       {4{ls2_srcpg_data_a1[11]}}, {4{ls2_srcpg_data_a1[10]}}, {4{ls2_srcpg_data_a1[ 9]}}, {4{ls2_srcpg_data_a1[ 8]}}};
 
   assign ls2_ld4_st4_parsed_pred_a1_uop2[31:0] =   {{4{ls2_srcpg_data_a1[23]}}, {4{ls2_srcpg_data_a1[22]}}, {4{ls2_srcpg_data_a1[21]}}, {4{ls2_srcpg_data_a1[20]}},
                                                       {4{ls2_srcpg_data_a1[19]}}, {4{ls2_srcpg_data_a1[18]}}, {4{ls2_srcpg_data_a1[17]}}, {4{ls2_srcpg_data_a1[16]}}} ;

   assign ls2_ld4_st4_parsed_pred_a1_uop3[31:0] =   {{4{ls2_srcpg_data_a1[31]}}, {4{ls2_srcpg_data_a1[30]}}, {4{ls2_srcpg_data_a1[29]}}, {4{ls2_srcpg_data_a1[28]}}, 
                                                       {4{ls2_srcpg_data_a1[27]}}, {4{ls2_srcpg_data_a1[26]}}, {4{ls2_srcpg_data_a1[25]}}, {4{ls2_srcpg_data_a1[24]}}};
 
  

   assign ls2_ld2_st2_parsed_pred_a1_uop1_vl16[15:0] =  ls2_ld2_st2_parsed_pred_a1_uop0[31:16]; 

   assign ls2_ld4_st4_parsed_pred_a1_uop1_vl16[15:0] =  ls2_ld4_st4_parsed_pred_a1_uop0[31:16];
 
   assign ls2_ld4_st4_parsed_pred_a1_uop2_vl16[15:0] =   {{4{ls2_srcpg_data_a1[11]}}, {4{ls2_srcpg_data_a1[10]}}, {4{ls2_srcpg_data_a1[ 9]}}, {4{ls2_srcpg_data_a1[ 8]}}}; 
   assign ls2_ld4_st4_parsed_pred_a1_uop3_vl16[15:0] =   {{4{ls2_srcpg_data_a1[15]}}, {4{ls2_srcpg_data_a1[14]}}, {4{ls2_srcpg_data_a1[13]}}, {4{ls2_srcpg_data_a1[12]}}}; 
 
   assign ls2_ld3_st3_parsed_pred_a1_uop1_vl16[15:0] =  ls2_ld3_st3_parsed_pred_a1_uop0[31:16];
 
   assign ls2_ld3_st3_parsed_pred_a1_uop2_vl16[15:0] =  { {3{ls2_srcpg_data_a1[15]}},
                                                            {3{ls2_srcpg_data_a1[14]}}, {3{ls2_srcpg_data_a1[13]}}, {3{ls2_srcpg_data_a1[12]}}, {3{ls2_srcpg_data_a1[11]}}, 
                                                            {{ls2_srcpg_data_a1[10]}}};




   assign ls2_valid_multi_reg_ld_st_op_a1 = ~(|ls_uop_ctl_ls2_a1_q[5:4]) &  (&ls_uop_ctl_ls2_a1_q[3:2]) & (|ls_uop_ctl_ls2_a1_q[1:0]);
   assign ls2_multi_reg_ld_st_op_a1[1:0] =  {2{ls2_valid_multi_reg_ld_st_op_a1}} & ls_uop_ctl_ls2_a1_q[1:0]; 


  always_ff @(posedge clk)
  begin: u_ls2_valid_multi_reg_ld_st_op_a2_q
    if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY ls2_valid_multi_reg_ld_st_op_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_valid_multi_reg_ld_st_op_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_comb 
  begin: u_ls2_ld_st_multi_reg_parsed_pred_a1_15_0
    casez({ls2_vl16_a1, ls2_multi_reg_ld_st_op_a1[1:0], ls2_uop_num_a1[1:0]})
      5'b?_0?_?0: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld2_st2_parsed_pred_a1_uop0[15:0];  
      5'b0_0?_?1: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld2_st2_parsed_pred_a1_uop1[15:0];  
      5'b1_0?_?1: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld2_st2_parsed_pred_a1_uop1_vl16[15:0];  
      5'b?_10_00: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld3_st3_parsed_pred_a1_uop0[15:0];  
      5'b0_10_?1: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld3_st3_parsed_pred_a1_uop1[15:0];  
      5'b0_10_10: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld3_st3_parsed_pred_a1_uop2[15:0];  
      5'b1_10_?1: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld3_st3_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_10_10: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld3_st3_parsed_pred_a1_uop2_vl16[15:0];  
      5'b?_11_00: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop0[15:0];  
      5'b0_11_01: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop1[15:0];  
      5'b0_11_10: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop2[15:0];  
      5'b0_11_11: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop3[15:0];  
      5'b1_11_01: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop1_vl16[15:0];  
      5'b1_11_10: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop2_vl16[15:0];  
      5'b1_11_11: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = ls2_ld4_st4_parsed_pred_a1_uop3_vl16[15:0];  
      default: ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls2_vl16_a1, ls2_multi_reg_ld_st_op_a1[1:0], ls2_uop_num_a1[1:0]})) === 1'bx)
      ls2_ld_st_multi_reg_parsed_pred_a1[15:0] = {16{1'bx}};
`endif
  end



  always_comb 
  begin: u_ls2_ld_st_multi_reg_parsed_pred_a1_31_16
    casez({ls2_vl16_a1, ls2_multi_reg_ld_st_op_a1[1:0], ls2_uop_num_a1[1:0]})
      5'b0_0?_?0: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld2_st2_parsed_pred_a1_uop0[31:16];  
      5'b0_0?_?1: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld2_st2_parsed_pred_a1_uop1[31:16];  
      5'b0_10_00: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld3_st3_parsed_pred_a1_uop0[31:16];  
      5'b0_10_?1: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld3_st3_parsed_pred_a1_uop1[31:16];  
      5'b0_10_10: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld3_st3_parsed_pred_a1_uop2[31:16];  
      5'b0_11_00: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld4_st4_parsed_pred_a1_uop0[31:16];  
      5'b0_11_01: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld4_st4_parsed_pred_a1_uop1[31:16];  
      5'b0_11_10: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld4_st4_parsed_pred_a1_uop2[31:16];  
      5'b0_11_11: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = ls2_ld4_st4_parsed_pred_a1_uop3[31:16];  
      5'b1_??_??: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = 16'h0000;  
      default: ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls2_vl16_a1, ls2_multi_reg_ld_st_op_a1[1:0], ls2_uop_num_a1[1:0]})) === 1'bx)
      ls2_ld_st_multi_reg_parsed_pred_a1[31:16] = {16{1'bx}};
`endif
  end



   assign ls2_cont_parsed_pred_a1[31:16] = ls2_srcpg_data_a1[31:16]; 
   assign ls2_cont_parsed_pred_a1[15:8]  =  ({8{ls2_el_ln_size_b_h_a1}} & ls2_compact_pred_el_ln_size_b_h_a1[15:8] ) | 
                                              ({8{ls2_el_ln_size_h_w_a1}} & ls2_compact_pred_el_ln_size_h_w_a1[15:8] ) | 
                                              ({8{ls2_el_ln_size_w_d_a1}} & ls2_compact_pred_el_ln_size_w_d_a1[15:8] ) | 
                                              ({8{ls2_el_ln_size_eq_a1}}  & ls2_srcpg_data_a1[15:8]);


   assign ls2_cont_parsed_pred_a1[7:4]  =   ({4{ls2_el_ln_size_b_h_a1}} & ls2_compact_pred_el_ln_size_b_h_a1[7:4] ) | 
                                              ({4{ls2_el_ln_size_b_w_a1}} & ls2_compact_pred_el_ln_size_b_w_a1[7:4] ) | 
                                              ({4{ls2_el_ln_size_h_w_a1}} & ls2_compact_pred_el_ln_size_h_w_a1[7:4] ) | 
                                              ({4{ls2_el_ln_size_h_d_a1}} & ls2_compact_pred_el_ln_size_h_d_a1[7:4] ) | 
                                              ({4{ls2_el_ln_size_w_d_a1}} & ls2_compact_pred_el_ln_size_w_d_a1[7:4] ) | 
                                              ({4{ls2_el_ln_size_eq_a1}}  & ls2_srcpg_data_a1[7:4]);

   assign ls2_cont_parsed_pred_a1[3:0]  =   ({4{ls2_el_ln_size_b_h_a1}} & ls2_compact_pred_el_ln_size_b_h_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_b_w_a1}} & ls2_compact_pred_el_ln_size_b_w_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_b_d_a1}} & ls2_compact_pred_el_ln_size_b_d_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_h_w_a1}} & ls2_compact_pred_el_ln_size_h_w_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_h_d_a1}} & ls2_compact_pred_el_ln_size_h_d_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_w_d_a1}} & ls2_compact_pred_el_ln_size_w_d_a1[3:0] ) | 
                                              ({4{ls2_el_ln_size_eq_a1}}  & ls2_srcpg_data_a1[3:0]);



  always_comb 
  begin: u_ls2_scatter_gather_parsed_pred_a1_7_0
    casez({ls2_scatter_gather_ln_num_a1_q[2:0], ls2_element_size_a1[1:0]})
      5'b000_??: ls2_scatter_gather_parsed_pred_a1[7:0] = ls2_cont_parsed_pred_a1[7:0];  
      5'b001_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[1]};  
      5'b001_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[3:2]};  
      5'b001_10: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[7:4]};  
      5'b001_11: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[15:8]};  
      5'b010_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[2]};  
      5'b010_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[5:4]};  
      5'b010_10: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[11:8]};  
      5'b010_11: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[23:16]};  
      5'b011_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[3]};  
      5'b011_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[7:6]};  
      5'b011_10: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[15:12]};  
      5'b011_11: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[31:24]};  
      5'b100_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[4]};  
      5'b100_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[9:8]};  
      5'b100_1?: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[19:16]};  
      5'b101_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[5]};  
      5'b101_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[11:10]};  
      5'b101_1?: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[23:20]};  
      5'b110_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[6]};  
      5'b110_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[13:12]};  
      5'b110_1?: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[27:24]};  
      5'b111_00: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:1], ls2_cont_parsed_pred_a1[7]};  
      5'b111_01: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:2], ls2_cont_parsed_pred_a1[15:14]};  
      5'b111_1?: ls2_scatter_gather_parsed_pred_a1[7:0] = {ls2_cont_parsed_pred_a1[7:4], ls2_cont_parsed_pred_a1[31:28]};  
      default: ls2_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls2_scatter_gather_ln_num_a1_q[2:0], ls2_element_size_a1[1:0]})) === 1'bx)
      ls2_scatter_gather_parsed_pred_a1[7:0] = {8{1'bx}};
`endif
  end


   assign ls2_parsed_pred_a1[7:0] =   ls2_scatter_gather_v_a1_q       ?  ls2_scatter_gather_parsed_pred_a1[7:0] :
                                        ls2_valid_multi_reg_ld_st_op_a1 ? ls2_ld_st_multi_reg_parsed_pred_a1[7:0] : 
                                                                           ls2_cont_parsed_pred_a1[7:0];

  assign ls2_parsed_pred_a1[31:8] =   ls2_valid_multi_reg_ld_st_op_a1 ? ls2_ld_st_multi_reg_parsed_pred_a1[31:8] : 
                                                                            ls2_cont_parsed_pred_a1[31:8];




  always_comb 
  begin: u_ls2_pred_mask_15_0
    casez(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: ls2_pred_mask[15:0] = 16'h0001;  
      `RV_BC_SIZE_H: ls2_pred_mask[15:0] = 16'h0003;  
      `RV_BC_SIZE_W: ls2_pred_mask[15:0] = 16'h000f;  
      `RV_BC_SIZE_D: ls2_pred_mask[15:0] = 16'h00ff;  
      `RV_BC_SIZE_16: ls2_pred_mask[15:0] = 16'hffff;  
      `RV_BC_SIZE_32: ls2_pred_mask[15:0] = 16'hffff;  
      default: ls2_pred_mask[15:0] = {16{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      ls2_pred_mask[15:0] = {16{1'bx}};
`endif
  end




  always_comb 
  begin: u_total_size_mask_ls2_a1_31_0
    casez(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_mask_ls2_a1[31:0] = 32'h0000_0001;  
      `RV_BC_SIZE_H: total_size_mask_ls2_a1[31:0] = 32'h0000_0003;  
      `RV_BC_SIZE_W: total_size_mask_ls2_a1[31:0] = 32'h0000_000f;  
      `RV_BC_SIZE_D: total_size_mask_ls2_a1[31:0] = 32'h0000_00ff;  
      `RV_BC_SIZE_16: total_size_mask_ls2_a1[31:0] = 32'h0000_ffff;  
      `RV_BC_SIZE_32: total_size_mask_ls2_a1[31:0] = 32'hffff_ffff;  
      default: total_size_mask_ls2_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_mask_ls2_a1[31:0] = {32{1'bx}};
`endif
  end




  always_comb 
  begin: u_byte_access_map_pre_pg_split_ls2_a1_31_0
    casez(ls2_fast_va_a1[4:0])
      5'b00000: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'hffff_ffff;  
      5'b00001: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h7fff_ffff;  
      5'b00010: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h3fff_ffff;  
      5'b00011: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h1fff_ffff;  
      5'b00100: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0fff_ffff;  
      5'b00101: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h07ff_ffff;  
      5'b00110: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h03ff_ffff;  
      5'b00111: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h01ff_ffff;  
      5'b01000: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h00ff_ffff;  
      5'b01001: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h007f_ffff;  
      5'b01010: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h003f_ffff;  
      5'b01011: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h001f_ffff;  
      5'b01100: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h000f_ffff;  
      5'b01101: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0007_ffff;  
      5'b01110: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0003_ffff;  
      5'b01111: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0001_ffff;  
      5'b10000: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_ffff;  
      5'b10001: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_7fff;  
      5'b10010: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_3fff;  
      5'b10011: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_1fff;  
      5'b10100: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_0fff;  
      5'b10101: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_07ff;  
      5'b10110: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_03ff;  
      5'b10111: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_01ff;  
      5'b11000: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_00ff;  
      5'b11001: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_007f;  
      5'b11010: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_003f;  
      5'b11011: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_001f;  
      5'b11100: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_000f;  
      5'b11101: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_0007;  
      5'b11110: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_0003;  
      5'b11111: byte_access_map_pre_pg_split_ls2_a1[31:0] = 32'h0000_0001;  
      default: byte_access_map_pre_pg_split_ls2_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls2_fast_va_a1[4:0])) === 1'bx)
      byte_access_map_pre_pg_split_ls2_a1[31:0] = {32{1'bx}};
`endif
  end

  

   assign byte_access_map_pre_ls2_a1[31:0] =  ls2_page_split1_early_val_a1 ? byte_access_map_pre_pg_split_ls2_a1[31:0]  : 
                                                ls2_page_split2_a1_q         ? (total_size_mask_ls2_a1[31:0] >> bytes_to_page_split_ls2_a2_q[4:0] ) :
                                                                                  total_size_mask_ls2_a1[31:0] ;
                                                                               

  always_ff @(posedge clk)
  begin: u_bytes_to_page_split_ls2_a2_q_4_0
    if (ls2_page_split1_early_val_a1 == 1'b1)
      bytes_to_page_split_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY bytes_to_page_split_ls2_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls2_page_split1_early_val_a1 == 1'b0)
    begin
    end
    else
      bytes_to_page_split_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_comb 
  begin: u_lanes_to_page_split_ls2_a2_4_0
    casez(ls2_element_size_a2[1:0])
      2'b00: lanes_to_page_split_ls2_a2[4:0] = bytes_to_page_split_ls2_a2_q[4:0];  
      2'b01: lanes_to_page_split_ls2_a2[4:0] = {1'b0, bytes_to_page_split_ls2_a2_q[4:1]};  
      2'b10: lanes_to_page_split_ls2_a2[4:0] = {2'b0, bytes_to_page_split_ls2_a2_q[4:2]};  
      2'b11: lanes_to_page_split_ls2_a2[4:0] = {3'b0, bytes_to_page_split_ls2_a2_q[4:3]};  
      default: lanes_to_page_split_ls2_a2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls2_element_size_a2[1:0])) === 1'bx)
      lanes_to_page_split_ls2_a2[4:0] = {5{1'bx}};
`endif
  end



  always_comb 
  begin: u_total_size_decoded_ls2_a1_5_0
    casez(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])
      `RV_BC_SIZE_B: total_size_decoded_ls2_a1[5:0] = 6'h01;  
      `RV_BC_SIZE_H: total_size_decoded_ls2_a1[5:0] = 6'h02;  
      `RV_BC_SIZE_W: total_size_decoded_ls2_a1[5:0] = 6'h04;  
      `RV_BC_SIZE_D: total_size_decoded_ls2_a1[5:0] = 6'h08;  
      `RV_BC_SIZE_16: total_size_decoded_ls2_a1[5:0] = 6'h10;  
      `RV_BC_SIZE_32: total_size_decoded_ls2_a1[5:0] = 6'h20;  
      default: total_size_decoded_ls2_a1[5:0] = {6{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE])) === 1'bx)
      total_size_decoded_ls2_a1[5:0] = {6{1'bx}};
`endif
  end





  

   assign ls2_parsed_pred_adjusted_a1[31:0] = ls2_page_split2_a1_q ?  ls2_parsed_pred_a1[31:0] >> bytes_to_page_split_ls2_a2_q[4:0]
                                                                       :  ls2_parsed_pred_a1[31:0]; 

   assign ls2_parsed_pred_adjusted_masked_a1[31:0] = ls2_parsed_pred_adjusted_a1[31:0] &  byte_access_map_pre_ls2_a1[31:0];

   assign first_vld_lane_found_ls2_a1 =  |ls2_parsed_pred_adjusted_masked_a1[31:0]; 

  always_comb 
  begin : first_active_byte_ls2
    integer i;
    first_active_byte_found_ls2_a1 = 1'b0;
    first_active_byte_ls2_a1[4:0] = 5'b0;
    for (i=0; i<32; i=i+1)
    begin : first_active_byte_loop_ls2
     if (ls2_parsed_pred_adjusted_a1[i] & ~first_active_byte_found_ls2_a1) 
     begin : first_active_byte_if_ls2_a1
      first_active_byte_found_ls2_a1 = 1'b1;
      first_active_byte_ls2_a1[4:0] = i;
     end
    end
  end


  always_ff @(posedge clk)
  begin: u_first_active_byte_pre_ls2_a1_4_0
    if (valid_xlat_uop_ls2_a1 == 1'b1)
      first_active_byte_pre_ls2_a1[4:0] <= `RV_BC_DFF_DELAY first_active_byte_ls2_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (valid_xlat_uop_ls2_a1 == 1'b0)
    begin
    end
    else
      first_active_byte_pre_ls2_a1[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign first_active_byte_ls2_a2[4:0] =   {5{ls2_srcpg_v_a2_q & ~(ld_val_ls2_a2_q & ls2_rep_ld_a2_q)}}
                                           & first_active_byte_pre_ls2_a1[4:0];


   assign byte_access_map_ls2_a1[31:0] =   
                                              ls2_ldg_ld_a1 ? 32'h0000_ffff :                                             
                                              byte_access_map_pre_ls2_a1[31:0]
                                           & (    {32{   ~ls2_srcpg_v_a1_q                         
                                                        | ld_val_ls2_a1 & ls2_rep_ld_a1          
                                                  }}
                                               |  ls2_parsed_pred_adjusted_a1[31:0]              
                                             )
                                          ;


  assign  bytes_to_page_split_ls2_a1[4:0] = bytes_to_cache_split_ls2_a1[4:0];




  assign {unused_bytes_ls2_a2[1:0], bytes_to_cache_split_ls2_a1[4:0]} = 7'h40 - {1'b0, ls2_cache_split2_a1_q ? va_ls2_a2_q[5:0] : ls2_fast_va_a1[5:0]};

   assign ls2_parsed_pred_split_adjusted_a1[31:0] = ls2_cache_split2_a1_q ?  ls2_parsed_pred_a1[31:0] >> bytes_to_cache_split_ls2_a1[4:0]
                                                                              :  ls2_parsed_pred_a1[31:0]; 

  assign ls2_split_adjusted_access_size_a1[5:0] = ls2_cache_split1_val_a1 ? {1'b0,bytes_to_cache_split_ls2_a1[4:0]}
                                                                              : total_size_decoded_ls2_a1[5:0] - ({1'b0,bytes_to_cache_split_ls2_a1[4:0]} & {6{ls2_cache_split2_a1_q}});


    assign byte_access_map_split_adjusted_ls2_a1[0] = ls2_split_adjusted_access_size_a1[5:0] > 6'd0;
    assign byte_access_map_split_adjusted_ls2_a1[1] = ls2_split_adjusted_access_size_a1[5:0] > 6'd1;
    assign byte_access_map_split_adjusted_ls2_a1[2] = ls2_split_adjusted_access_size_a1[5:0] > 6'd2;
    assign byte_access_map_split_adjusted_ls2_a1[3] = ls2_split_adjusted_access_size_a1[5:0] > 6'd3;
    assign byte_access_map_split_adjusted_ls2_a1[4] = ls2_split_adjusted_access_size_a1[5:0] > 6'd4;
    assign byte_access_map_split_adjusted_ls2_a1[5] = ls2_split_adjusted_access_size_a1[5:0] > 6'd5;
    assign byte_access_map_split_adjusted_ls2_a1[6] = ls2_split_adjusted_access_size_a1[5:0] > 6'd6;
    assign byte_access_map_split_adjusted_ls2_a1[7] = ls2_split_adjusted_access_size_a1[5:0] > 6'd7;
    assign byte_access_map_split_adjusted_ls2_a1[8] = ls2_split_adjusted_access_size_a1[5:0] > 6'd8;
    assign byte_access_map_split_adjusted_ls2_a1[9] = ls2_split_adjusted_access_size_a1[5:0] > 6'd9;
    assign byte_access_map_split_adjusted_ls2_a1[10] = ls2_split_adjusted_access_size_a1[5:0] > 6'd10;
    assign byte_access_map_split_adjusted_ls2_a1[11] = ls2_split_adjusted_access_size_a1[5:0] > 6'd11;
    assign byte_access_map_split_adjusted_ls2_a1[12] = ls2_split_adjusted_access_size_a1[5:0] > 6'd12;
    assign byte_access_map_split_adjusted_ls2_a1[13] = ls2_split_adjusted_access_size_a1[5:0] > 6'd13;
    assign byte_access_map_split_adjusted_ls2_a1[14] = ls2_split_adjusted_access_size_a1[5:0] > 6'd14;
    assign byte_access_map_split_adjusted_ls2_a1[15] = ls2_split_adjusted_access_size_a1[5:0] > 6'd15;
    assign byte_access_map_split_adjusted_ls2_a1[16] = ls2_split_adjusted_access_size_a1[5:0] > 6'd16;
    assign byte_access_map_split_adjusted_ls2_a1[17] = ls2_split_adjusted_access_size_a1[5:0] > 6'd17;
    assign byte_access_map_split_adjusted_ls2_a1[18] = ls2_split_adjusted_access_size_a1[5:0] > 6'd18;
    assign byte_access_map_split_adjusted_ls2_a1[19] = ls2_split_adjusted_access_size_a1[5:0] > 6'd19;
    assign byte_access_map_split_adjusted_ls2_a1[20] = ls2_split_adjusted_access_size_a1[5:0] > 6'd20;
    assign byte_access_map_split_adjusted_ls2_a1[21] = ls2_split_adjusted_access_size_a1[5:0] > 6'd21;
    assign byte_access_map_split_adjusted_ls2_a1[22] = ls2_split_adjusted_access_size_a1[5:0] > 6'd22;
    assign byte_access_map_split_adjusted_ls2_a1[23] = ls2_split_adjusted_access_size_a1[5:0] > 6'd23;
    assign byte_access_map_split_adjusted_ls2_a1[24] = ls2_split_adjusted_access_size_a1[5:0] > 6'd24;
    assign byte_access_map_split_adjusted_ls2_a1[25] = ls2_split_adjusted_access_size_a1[5:0] > 6'd25;
    assign byte_access_map_split_adjusted_ls2_a1[26] = ls2_split_adjusted_access_size_a1[5:0] > 6'd26;
    assign byte_access_map_split_adjusted_ls2_a1[27] = ls2_split_adjusted_access_size_a1[5:0] > 6'd27;
    assign byte_access_map_split_adjusted_ls2_a1[28] = ls2_split_adjusted_access_size_a1[5:0] > 6'd28;
    assign byte_access_map_split_adjusted_ls2_a1[29] = ls2_split_adjusted_access_size_a1[5:0] > 6'd29;
    assign byte_access_map_split_adjusted_ls2_a1[30] = ls2_split_adjusted_access_size_a1[5:0] > 6'd30;
    assign byte_access_map_split_adjusted_ls2_a1[31] = ls2_split_adjusted_access_size_a1[5:0] > 6'd31;

   assign ls2_parsed_pred_split_adjusted_masked_a1[31:0] = ls2_parsed_pred_split_adjusted_a1[31:0] &  byte_access_map_split_adjusted_ls2_a1[31:0];

   assign vld_split_lane_found_ls2_a1 = ~ls2_srcpg_v_a1_q | (ls2_rep_ld_a1 ? ~ls2_rep_pred_zero_a1 : (|ls2_parsed_pred_split_adjusted_masked_a1[31:0]));
  
   assign ls2_lo_pred_non_zero_a1 = (|(ls2_parsed_pred_a1[15:0] & ls2_pred_mask[15:0]));
   assign ls2_hi_pred_non_zero_a1 = (|(ls2_parsed_pred_a1[31:16] & ls2_pred_mask[15:0]));


   assign ls2_lo_pred_zero_a1 = ~ls2_lo_pred_non_zero_a1;
   assign ls2_hi_pred_zero_a1 = ~ls2_hi_pred_non_zero_a1;

   assign ls2_rep_ld_a1 = (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R);

   assign ls2_qrep_ld_a1 = ( ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ);

   assign ls2_rep_pred_zero_a1 = ~(|ls2_srcpg_data_a1[31:0]);




  
   assign ls2_spe_zero_pg_rep_qrep =   ls2_qrep_ld_a1                   ? ~(|ls2_parsed_pred_adjusted_masked_a1[15:0]):
                                       (~ls_sve_vl_256_q & ls2_rep_ld_a1) ? ~(|ls2_srcpg_data_pq_a1[15:0]) :
                                       ( ls_sve_vl_256_q & ls2_rep_ld_a1) ? ~(|ls2_srcpg_data_pq_a1[31:0]) :
                                                                                1'b0;
   assign ls2_spe_zero_pg_non_qrep =   ls_sve_vl_256_q ? ~(|ls2_parsed_pred_adjusted_masked_a1[31:0]) :
                                                           ~(|ls2_parsed_pred_adjusted_masked_a1[15:0]);

   assign ls2_spe_part_pg_non_qrep = ls_sve_vl_256_q ? |(~ls2_parsed_pred_adjusted_a1[31:0] & byte_access_map_pre_ls2_a1[31:0]) :
                                                         |(~ls2_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls2_a1[15:0]);

   assign ls2_spe_part_pg_uop_qrep = |(~ls2_parsed_pred_adjusted_a1[15:0] & byte_access_map_pre_ls2_a1[15:0]);
  
   assign ls2_spe_part_pg_rep_qrep =    ls2_qrep_ld_a1                    ?   ls2_spe_part_pg_uop_qrep     :
                                        (~ls_sve_vl_256_q & ls2_rep_ld_a1)  ? ~(&ls2_srcpg_data_pq_a1[15:0]) :
                                        ( ls_sve_vl_256_q & ls2_rep_ld_a1)  ? ~(&ls2_srcpg_data_pq_a1[31:0]) :
                                                                                  1'b0 ;

   assign ls2_spe_part_pg_uop     = (ls2_qrep_ld_a1 | ls2_rep_ld_a1) ? ls2_spe_part_pg_rep_qrep : ls2_spe_part_pg_non_qrep;
   assign ls2_spe_zero_pg_uop     = (ls2_qrep_ld_a1 | ls2_rep_ld_a1) ? ls2_spe_zero_pg_rep_qrep : ls2_spe_zero_pg_non_qrep;
   assign ls2_empty_predicate     = ls2_spe_zero_pg_uop & ls2_srcpg_v_a1_q;
   assign ls2_partial_predicate   = ls2_spe_part_pg_uop & ls2_srcpg_v_a1_q;
   

   assign ls2_pred_all_inv_a1 = ls2_srcpg_v_a1_q & (ls2_lo_pred_zero_a1 &  ( ( ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_T_SIZE] != `RV_BC_SIZE_32 ) | ls2_hi_pred_zero_a1)); 

   

   assign ls2_ccpass_st_mod_a1 =    ccpass_ls2_a1
                                   & ( ~ls2_pred_all_inv_a1
                                      | ls2_sp_align_flt_a1              
                                      | ls2_page_split2_a1_q 
                                        & ls2_sp_align_flt_a2_q)         
                                 ;
                                     

  always_ff @(posedge clk)
  begin: u_ls2_ccpass_st_a2_q
    if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_ccpass_st_a2_q <= `RV_BC_DFF_DELAY ls2_ccpass_st_mod_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_ccpass_st_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


   assign ls2_pred_inv_force_ccfail_a1 =   ls2_srcpg_v_a1_q 
                                          & ( ls2_rep_ld_a1 ? ls2_rep_pred_zero_a1 
                                                              : (  ~first_vld_lane_found_ls2_a1 
                                                                  & ~(ls2_page_split1_early_val_a1 & prevent_unalign_ls2_a1) 
                                                                )
                                            )
                                          & ~ls2_sp_align_flt_a1 ;              
                                           




 assign ls2_srcpg_data_pq_a1[31:0] = ls2_valid_multi_reg_ld_st_op_a1 ? ls2_ld_st_multi_reg_parsed_pred_a1[31:0] : 
                                       ls2_qrep_ld_a1 ? {16'h0000, ls2_srcpg_data_a1[15:0]} : 
                                                                     ls2_srcpg_data_a1[31:0];

 

  always_ff @(posedge clk)
  begin: u_ls2_srcpg_data_a2_q_31_0
    if (ls2_srcpg_v_a1_q == 1'b1)
      ls2_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY ls2_srcpg_data_pq_a1[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls2_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls2_srcpg_data_a2_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls2_ln_size_a2_q_1_0
    if (ls2_srcpg_v_a1_q == 1'b1)
      ls2_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY ls2_ln_size_a1_q[1:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls2_srcpg_v_a1_q == 1'b0)
    begin
    end
    else
      ls2_ln_size_a2_q[1:0] <= `RV_BC_DFF_DELAY {2{1'bx}};
`endif
  end


 





  always_comb 
  begin: u_contiguous_lane_vlds_ls2_a1_31_0
    casez(ls2_ln_size_a1_q[1:0])
      2'b00: contiguous_lane_vlds_ls2_a1[31:0] = ls2_srcpg_data_a1_q[31:0];  
      2'b01: contiguous_lane_vlds_ls2_a1[31:0] = {16'b0, ls2_srcpg_data_a1_q[30], ls2_srcpg_data_a1_q[28], ls2_srcpg_data_a1_q[26], ls2_srcpg_data_a1_q[24], ls2_srcpg_data_a1_q[22], ls2_srcpg_data_a1_q[20], ls2_srcpg_data_a1_q[18], ls2_srcpg_data_a1_q[16], ls2_srcpg_data_a1_q[14], ls2_srcpg_data_a1_q[12], ls2_srcpg_data_a1_q[10], ls2_srcpg_data_a1_q[8], ls2_srcpg_data_a1_q[6], ls2_srcpg_data_a1_q[4], ls2_srcpg_data_a1_q[2], ls2_srcpg_data_a1_q[0]};  
      2'b10: contiguous_lane_vlds_ls2_a1[31:0] = {24'b0, ls2_srcpg_data_a1_q[28], ls2_srcpg_data_a1_q[24], ls2_srcpg_data_a1_q[20], ls2_srcpg_data_a1_q[16], ls2_srcpg_data_a1_q[12], ls2_srcpg_data_a1_q[8], ls2_srcpg_data_a1_q[4], ls2_srcpg_data_a1_q[0]};  
      2'b11: contiguous_lane_vlds_ls2_a1[31:0] = {28'b0, ls2_srcpg_data_a1_q[24], ls2_srcpg_data_a1_q[16], ls2_srcpg_data_a1_q[8], ls2_srcpg_data_a1_q[0]};  
      default: contiguous_lane_vlds_ls2_a1[31:0] = {32{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^(ls2_ln_size_a1_q[1:0])) === 1'bx)
      contiguous_lane_vlds_ls2_a1[31:0] = {32{1'bx}};
`endif
  end


  always_comb 
  begin : find_raw_pred_first_active_lane_ls2_a1
    integer i;
    raw_pred_first_vld_lane_found_ls2_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_first_active_lane_loop_ls2_a1
     raw_pred_first_active_lane_dec_ls2_a1[i] = ~raw_pred_first_vld_lane_found_ls2_a1 & contiguous_lane_vlds_ls2_a1[i] ;
     if (contiguous_lane_vlds_ls2_a1[i])
     begin : find_raw_pred_first_active_lane_if_ls2_a1
      raw_pred_first_vld_lane_found_ls2_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_first_active_lane_ls2_a1_4_0
    raw_pred_first_active_lane_ls2_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_first_active_lane_dec_ls2_a1[macro_i])
        raw_pred_first_active_lane_ls2_a1[4:0] = raw_pred_first_active_lane_ls2_a1[4:0] | macro_i[4:0];
  end


  always_comb 
  begin : find_raw_pred_second_active_lane_ls2_a1
    integer i;
    raw_pred_first_vld_lane_found_2_ls2_a1 = 1'b0;
    raw_pred_second_vld_lane_found_ls2_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : find_raw_pred_second_active_lane_loop_ls2_a1
     raw_pred_second_lane_dec_ls2_a1[i] = ~(raw_pred_first_vld_lane_found_2_ls2_a1 & raw_pred_second_vld_lane_found_ls2_a1) & raw_pred_first_vld_lane_found_2_ls2_a1 & contiguous_lane_vlds_ls2_a1[i]  ;
     if (contiguous_lane_vlds_ls2_a1[i])
     begin : find_raw_pred_second_active_lane_if_1_ls2_a1
      if (raw_pred_first_vld_lane_found_2_ls2_a1)
      begin:  find_raw_pred_second_active_lane_if_2_ls2_a1
       raw_pred_second_vld_lane_found_ls2_a1= 1'b1;
      end
      raw_pred_first_vld_lane_found_2_ls2_a1= 1'b1;
     end
    end
  end


  always_comb 
  begin: u_raw_pred_second_lane_ls2_a1_4_0
    raw_pred_second_lane_ls2_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (raw_pred_second_lane_dec_ls2_a1[macro_i])
        raw_pred_second_lane_ls2_a1[4:0] = raw_pred_second_lane_ls2_a1[4:0] | macro_i[4:0];
  end


  assign ff_ld_ls2_a1 = ff_cont_ld_ls2_a1 | ff_gather_ld_ls2_a1;
  assign unalign_ls2_a1_a2 = unalign1_ls2_a1 | unalign2_ls2_a1_q ; 
  assign page_split_ls2_a1_a2 = ls2_page_split1_val_a1 | ls2_ld_page_split2_a1; 

  assign chk_bit_ff_ld_ffr_upd_poss_ls2_a1 = ld_val_ls2_a1 & (   ff_cont_ld_ls2_a1 & raw_pred_second_vld_lane_found_ls2_a1
                                                                   | ff_gather_ld_ls2_a1 & ~scatter_gather_cur_lane_eq_first_active_lane_ls2_a1
                                                                 ) ;

  assign chk_bit_nf_ld_ffr_upd_poss_ls2_a1 = ld_val_ls2_a1 & nf_ld_ls2_a1 & raw_pred_first_vld_lane_found_ls2_a1;

  assign chk_bit_ffr_upd_ls2_a1 =    (ls_ff_nf_ld_ffr_upd_always | ls_ff_nf_ld_ffr_cons_upd_on_exptn) & (chk_bit_ff_ld_ffr_upd_poss_ls2_a1 | chk_bit_nf_ld_ffr_upd_poss_ls2_a1)
                                     | ls_unalign_ff_ld_ffr_cons_upd_on_exptn     & chk_bit_ff_ld_ffr_upd_poss_ls2_a1 & unalign_ls2_a1_a2
                                     | ls_unalign_nf_ld_ffr_cons_upd_on_exptn     & chk_bit_nf_ld_ffr_upd_poss_ls2_a1 & unalign_ls2_a1_a2 
                                     | ls_page_split_ff_ld_ffr_cons_upd_on_exptn  & chk_bit_ff_ld_ffr_upd_poss_ls2_a1 & page_split_ls2_a1_a2
                                     | ls_page_split_nf_ld_ffr_cons_upd_on_exptn  & chk_bit_nf_ld_ffr_upd_poss_ls2_a1 & page_split_ls2_a1_a2; 

  assign chk_bit_ffr_lane_ls2_a1[4:0] =   ( {5{ff_cont_ld_ls2_a1}}           & raw_pred_second_lane_ls2_a1[4:0])
                                          | ( {5{nf_ld_ls2_a1}}                & raw_pred_first_active_lane_ls2_a1[4:0])
                                          | ( {5{not_nf_or_ff_cont_ld_ls2_a1}} & {2'b0, ls2_scatter_gather_ln_num_a1_q[2:0]});  


  always_ff @(posedge clk)
  begin: u_chk_bit_ffr_upd_ls2_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b1)
      chk_bit_ffr_upd_ls2_a2_q <= `RV_BC_DFF_DELAY chk_bit_ffr_upd_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_upd_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


 assign chk_bit_ffr_upd_clk_en_ls2_a1 =      ff_or_nf_ld_a2_flops_clk_en_ls2_a1 
                                             | ls_ff_nf_ld_ffr_upd_always 
                                             | ls_ff_nf_ld_ffr_cons_upd_on_exptn
                                             | ls_unalign_ff_ld_ffr_cons_upd_on_exptn    
                                             | ls_unalign_nf_ld_ffr_cons_upd_on_exptn    
                                             | ls_page_split_ff_ld_ffr_cons_upd_on_exptn 
                                             | ls_page_split_nf_ld_ffr_cons_upd_on_exptn;  
 

  always_ff @(posedge clk_agu2)
  begin: u_chk_bit_ffr_lane_ls2_a2_q_4_0
    if (chk_bit_ffr_upd_clk_en_ls2_a1 == 1'b1)
      chk_bit_ffr_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY chk_bit_ffr_lane_ls2_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (chk_bit_ffr_upd_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      chk_bit_ffr_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_comb 
  begin : find_page_split_lane_mask_ls2
    integer i;
    first_one_found_ls2_a2 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : page_split_lane_mask_loop_ls2
     if (lanes_to_page_split_ls2_a2[4:0] == i)
      first_one_found_ls2_a2 = 1'b1;
      page_split_lane_mask_ls2_a2[i] = first_one_found_ls2_a2;
    end
  end



   assign ffr_vlds_ls2_a1[31:0] =   (   {32{~ls2_page_split2_a1_q | not_nf_or_ff_cont_ld_ls2_a1}}                                                                                                                                | {{32{ls2_page_split2_a1_q}}    &  page_split_lane_mask_ls2_a2[31:0]}                                                    
                                      )
                                    &  contiguous_lane_vlds_ls2_a1[31:0]; 

  always_comb 
  begin : find_ffr_lane_ls2_a1
    integer i;
    vld_lane_found_ls2_a1 = 1'b0;
    for (i=0; i<32; i=i+1)
    begin : ffr_lane_loop_ls2
     cont_ld_ffr_lane_dec_ls2_a1[i] = ~vld_lane_found_ls2_a1 & ffr_vlds_ls2_a1[i] ;
     if (ffr_vlds_ls2_a1[i])
     begin : first_vld_lane_found_if_ls2_a1
      vld_lane_found_ls2_a1 = 1'b1;
     end
    end
  end


  always_comb 
  begin : find_last_lane_ls2_a1
    integer i;
    vld_last_lane_found_ls2_a1 = 1'b0;
    for (i=31; i>=0; i=i-1)
    begin : last_lane_loop_ls2
     cont_ld_last_lane_dec_ls2_a1[i] = ~vld_last_lane_found_ls2_a1 & ffr_vlds_ls2_a1[i] ;
     if (ffr_vlds_ls2_a1[i])
     begin : first_vld_lane_found_if_ls2_a1
      vld_last_lane_found_ls2_a1 = 1'b1;
     end
    end
  end


  


  assign more_than_one_active_lane_pre_ls2_a1 = (cont_ld_ffr_lane_dec_ls2_a1[31:0] != cont_ld_last_lane_dec_ls2_a1[31:0]);


  always_ff @(posedge clk)
  begin: u_more_than_one_active_lane_pre_ls2_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b1)
      more_than_one_active_lane_pre_ls2_a2_q <= `RV_BC_DFF_DELAY more_than_one_active_lane_pre_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      more_than_one_active_lane_pre_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign more_than_one_active_lane_ls2_a2 =   ls2_page_split2_a1_q  & page_split1_more_than_one_active_lane_ls2_a2 
                                              | ls2_page_split2_a2_q  & first_vld_lane_found_ls2_a3_q
                                              | ~ls2_page_split2_a1_q & more_than_one_active_lane_pre_ls2_a2_q;


  assign page_split1_more_than_one_active_lane_ls2_a2 = (cont_ld_ffr_lane_ls2_a1[4:0] != raw_pred_second_lane_ls2_a2_q[4:0]) & ~(mid_first_lane_page_split_ls2_a2 & (|(ffr_vlds_ls2_a1[31:0]))) ;

  assign mid_first_lane_page_split_ls2_a2 = (ffr_lane_ls2_a2_q[4:0] == cont_ld_ffr_lane_ls2_a1[4:0]);



  always_comb 
  begin: u_cont_ld_ffr_lane_ls2_a1_4_0
    cont_ld_ffr_lane_ls2_a1[4:0] = {5{1'b0}};
    for (integer macro_i=0; macro_i<=31; macro_i=macro_i+1)
      if (cont_ld_ffr_lane_dec_ls2_a1[macro_i])
        cont_ld_ffr_lane_ls2_a1[4:0] = cont_ld_ffr_lane_ls2_a1[4:0] | macro_i[4:0];
  end





  assign ff_or_nf_ld_a2_flops_clk_en_ls2_a1 = (ff_cont_ld_ls2_a1 | ff_gather_ld_ls2_a1 | nf_ld_ls2_a1) & ld_val_ls2_a1; 


  always_ff @(posedge clk)
  begin: u_raw_pred_second_lane_ls2_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b1)
      raw_pred_second_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY raw_pred_second_lane_ls2_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      raw_pred_second_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  assign cont_ld_second_ffr_lane_ls2_a2[4:0] = ls2_page_split2_a2_q & first_vld_lane_found_ls2_a3_q & ~mid_first_lane_page_split_ls2_a3_q ? ffr_lane_ls2_a2_q[4:0]
                                                                                                                                                  : raw_pred_second_lane_ls2_a2_q[4:0];

  assign ffr_lane_ls2_a1[4:0] =  ( {5{~not_nf_or_ff_cont_ld_ls2_a1}} &  cont_ld_ffr_lane_ls2_a1[4:0])                   
                                 | ( {5{ ff_gather_ld_ls2_a1}}         & {2'b0, ls2_scatter_gather_ln_num_a1_q[2:0]}) ;   


  always_ff @(posedge clk)
  begin: u_ffr_lane_ls2_a2_q_4_0
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b1)
      ffr_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY ffr_lane_ls2_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      ffr_lane_ls2_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_ff_cont_ld_ls2_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      ff_cont_ld_ls2_a2_q <= `RV_BC_DFF_DELAY ff_cont_ld_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ff_cont_ld_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_cont_ld_ls2_a2 = ld_val_ls2_a2_q & ff_cont_ld_ls2_a2_q;


  always_ff @(posedge clk)
  begin: u_nf_ld_ls2_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      nf_ld_ls2_a2_q <= `RV_BC_DFF_DELAY nf_ld_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      nf_ld_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign nf_ld_ls2_a2 = ld_val_ls2_a2_q & nf_ld_ls2_a2_q;


  always_ff @(posedge clk)
  begin: u_ff_gather_ld_ls2_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      ff_gather_ld_ls2_a2_q <= `RV_BC_DFF_DELAY ff_gather_ld_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ff_gather_ld_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls2_rep_ld_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      ls2_rep_ld_a2_q <= `RV_BC_DFF_DELAY ls2_rep_ld_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ls2_rep_ld_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_gather_ld_ls2_a2 = ld_val_ls2_a2_q & ff_gather_ld_ls2_a2_q;

  assign ff_ld_ls2_a2 = ff_cont_ld_ls2_a2 | ff_gather_ld_ls2_a2;

  assign ff_or_nf_ld_ls2_a2 = ff_ld_ls2_a2 | nf_ld_ls2_a2 ;


  assign scatter_gather_cur_lane_eq_first_active_lane_ls2_a1 =    (ls2_scatter_gather_ln_num_a1_q[2:0] == cont_ld_ffr_lane_ls2_a1[2:0]);



  always_ff @(posedge clk)
  begin: u_scatter_gather_cur_lane_eq_first_active_lane_ls2_a2_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b1)
      scatter_gather_cur_lane_eq_first_active_lane_ls2_a2_q <= `RV_BC_DFF_DELAY scatter_gather_cur_lane_eq_first_active_lane_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a1 == 1'b0)
    begin
    end
    else
      scatter_gather_cur_lane_eq_first_active_lane_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls2_a2_q
    if (any_issue_v_ls2_i2_a2 == 1'b1)
      first_vld_lane_found_ls2_a2_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls2_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  assign ff_or_nf_ld_a2_flops_clk_en_ls2_a2 = ff_or_nf_ld_ls2_a2 & ld_val_ls2_a2_q; 


  always_ff @(posedge clk)
  begin: u_ffr_lane_eq_first_active_lane_ls2_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b1)
      ffr_lane_eq_first_active_lane_ls2_a3_q <= `RV_BC_DFF_DELAY ffr_lane_eq_first_active_lane_ls2_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b0)
    begin
    end
    else
      ffr_lane_eq_first_active_lane_ls2_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end





  always_ff @(posedge clk)
  begin: u_mid_first_lane_page_split_ls2_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b1)
      mid_first_lane_page_split_ls2_a3_q <= `RV_BC_DFF_DELAY mid_first_lane_page_split_ls2_a2;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b0)
    begin
    end
    else
      mid_first_lane_page_split_ls2_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_first_vld_lane_found_ls2_a3_q
    if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b1)
      first_vld_lane_found_ls2_a3_q <= `RV_BC_DFF_DELAY first_vld_lane_found_ls2_a2_q;
`ifdef RV_BC_XPROP_FLOP
    else if (ff_or_nf_ld_a2_flops_clk_en_ls2_a2 == 1'b0)
    begin
    end
    else
      first_vld_lane_found_ls2_a3_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ffr_lane_eq_first_active_lane_ls2_a2 =   ls2_sp_align_flt_a2_q                                                                                      
                                                  | ( not_nf_or_ff_cont_ld_ls2_a2              ? scatter_gather_cur_lane_eq_first_active_lane_ls2_a2_q :
                                                      ld_val_ls2_a2_q & ls2_page_split2_a2_q ?  (  ~ffr_lane_eq_first_active_lane_ls2_a3_q                 
 
                                                                                                      | mid_first_lane_page_split_ls2_a3_q                     
                                                                                                    ) &  first_vld_lane_found_ls2_a2_q   
                                                                                                 : first_vld_lane_found_ls2_a2_q
                                                    );  




  assign first_vld_lane_found_ls2_a2 =    first_vld_lane_found_ls2_a2_q
                                         |  ld_val_ls2_a2_q & ls2_rep_ld_a2_q            
                                         | ~ls2_srcpg_v_a2_q                               
                                         |  ls2_sp_align_flt_a2_q;                         





  assign ls2_ld_reject_gather_nxt_i2 = ls2_ld_reject_gather_i2 & issue_v_ls2_i2;

  rv_bc_dffr #(.W(1)) u_unalign2_ls2_a1_0 (.q(unalign2_ls2_a1_q),                            .din(unalign2_ls2_i2),                             .clk(clk), .en(any_issue_v_ls2_i2_a2), .reset(reset_i));
  rv_bc_dffr #(.W(1)) u_unalign2_ls2_a1_1 (.q(unalign2_dup_ls2_a1_q),                        .din(unalign2_ls2_i2),                             .clk(clk), .en(any_issue_v_ls2_i2_a2), .reset(reset_i));

  always_ff @(posedge clk or posedge reset_i)
  begin: u_unalign2_ls2_a2_q
    if (reset_i == 1'b1)
      unalign2_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      unalign2_ls2_a2_q <= `RV_BC_DFF_DELAY unalign2_ls2_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      unalign2_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      unalign2_ls2_a2_q <= `RV_BC_DFF_DELAY unalign2_ls2_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_page_split2_a1_q
    if (reset_i == 1'b1)
      ls2_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_page_split2_a1_q <= `RV_BC_DFF_DELAY ls2_page_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_page_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_page_split2_a1_q <= `RV_BC_DFF_DELAY ls2_page_split1_val_a1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_page_split2_a2_q
    if (reset_i == 1'b1)
      ls2_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_page_split2_a2_q <= `RV_BC_DFF_DELAY ls2_page_split2_a1_q;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_page_split2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_page_split2_a2_q <= `RV_BC_DFF_DELAY ls2_page_split2_a1_q;
`endif
  end


  assign ls2_a1_reject_i2 =    ls2_ld_reject_gather_nxt_i2
                              |   ls_ff_nf_ld_ffr_upd_always & issue_ld_val_ls2_i2                                                             
                                & (   (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_CONT_FF_LD) 
                                    | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_FF_LD) 
                                    | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD) 
                                  )
                                & ~ls2_precommit_uop_i2_unqual
                                & ~address_inject_val_ls2_i2_q;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_a1_reject_a1_q
    if (reset_i == 1'b1)
      ls2_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls2_a1_reject_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_a1_reject_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_a1_reject_a1_q <= `RV_BC_DFF_DELAY ls2_a1_reject_i2;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls2_i2_q
    if (reset_i == 1'b1)
      address_inject_val_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls2_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_i1;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls2_i2_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_i1;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls2_a1_q
    if (reset_i == 1'b1)
      address_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_i2_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_i2_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_address_inject_val_ls2_a2_q
    if (reset_i == 1'b1)
      address_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      address_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      address_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      address_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY address_inject_val_ls2_a1_q;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls2_a1_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls2_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls2_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_val_ls2_a2_q
    if (reset_i == 1'b1)
      tmo_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls2_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY tmo_inject_val_ls2_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls2_a1_q
    if (reset_i == 1'b1)
      spe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls2_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY spe_inject_val_ls2_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_val_ls2_a2_q
    if (reset_i == 1'b1)
      spe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls2_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY spe_inject_val_ls2_a1_q;
`endif
  end



  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls2_a1_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls2_i2;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls2_a1_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls2_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_val_ls2_a2_q
    if (reset_i == 1'b1)
      tbe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls2_a1_q;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_val_ls2_a2_q <= `RV_BC_DFF_DELAY tbe_inject_val_ls2_a1_q;
`endif
  end




  always_ff @(posedge clk)
  begin: u_uid_ls2_i2_q_8_0
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      uid_ls2_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY is_ls_uid_ls2_i1[`RV_BC_UID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      uid_ls2_i2_q[`RV_BC_UID] <= `RV_BC_DFF_DELAY {9{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_rid_ls2_i2_q
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      rid_ls2_i2_q <= `RV_BC_DFF_DELAY is_ls_rid_ls2_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      rid_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



   

  always_ff @(posedge clk)
  begin: u_ls2_stid_i2_q_6_0
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      ls2_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY is_ls_stid_ls2_i1[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      ls2_stid_i2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resx_ls2_i2_q
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      dep_d4_resx_ls2_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resx_ls2_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resx_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resy_ls2_i2_q
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      dep_d4_resy_ls2_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resy_ls2_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resy_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_dep_d4_resz_ls2_i2_q
    if (is_ls_issue_v_ls2_i1 == 1'b1)
      dep_d4_resz_ls2_i2_q <= `RV_BC_DFF_DELAY is_ls_dep_d3_resz_ls2_i1;
`ifdef RV_BC_XPROP_FLOP
    else if (is_ls_issue_v_ls2_i1 == 1'b0)
    begin
    end
    else
      dep_d4_resz_ls2_i2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk_agu2)
  begin: u_stid_ls2_a1_q_6_0
    if (issue_v_poss_ls2_i2 == 1'b1)
      stid_ls2_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY ls2_stid_i2_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      stid_ls2_a1_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_tmp_ls_uop_ctl_ls2_a1_q_21_0
    if (issue_v_poss_ls2_i2 == 1'b1)
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SP_BASE:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SP_BASE:0] <= `RV_BC_DFF_DELAY {22{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_tmp_ls_uop_ctl_ls2_a1_q_26
    if (issue_v_poss_ls2_i2 == 1'b1)
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_IL];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_IL] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_tmp_ls_uop_ctl_ls2_a1_q_27
    if (issue_v_poss_ls2_i2 == 1'b1)
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_HSR_ISS_V];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_V] <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_tmp_ls_uop_ctl_ls2_a1_q_32_28
    if (issue_v_poss_ls2_i2 == 1'b1)
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_HSR_ISS_RT];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_precommit_uop_a1_q
    if (reset_i == 1'b1)
      ls2_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls2_i2 == 1'b1)
      ls2_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls2_precommit_uop_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      ls2_precommit_uop_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls2_i2 == 1'b1)
      ls2_precommit_uop_a1_q <= `RV_BC_DFF_DELAY ls2_precommit_uop_i2;
`endif
  end



  always_ff @(posedge clk)
  begin: u_stid_ls2_a2_q_6_0
    if (op_val_ls2_a1 == 1'b1)
      stid_ls2_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY stid_ls2_a1_q[`RV_BC_STID];
`ifdef RV_BC_XPROP_FLOP
    else if (op_val_ls2_a1 == 1'b0)
    begin
    end
    else
      stid_ls2_a2_q[`RV_BC_STID] <= `RV_BC_DFF_DELAY {7{1'bx}};
`endif
  end


  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT] = tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_RT];
  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_V]  = tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_HSR_ISS_V];
  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_IL]         = tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_IL];
  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SP_BASE:0]  = tmp_ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SP_BASE:0];
  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SRCB_EXT]   = 2'b00; 
  assign ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SRCB_SH]    = 2'b00; 

  assign ls2_sp_base_a1            = ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_SP_BASE]; 

  assign ls2_ld_unalign1_a2        =  (ld_val_ls2_a2_q & unalign2_ls2_a1_q);
  assign ls2_ld_page_split1_a2     =  (ld_val_ls2_a2_q & ls2_page_split2_a1_q);
  assign ls2_st_page_split1_a2     =  (st_val_ls2_a2_q & ls2_page_split2_a1_q);

  assign ls2_ld_unalign2_a1        =  (ld_val_ls2_a2_q & unalign2_ls2_a1_q);
  assign ls2_ld_page_split2_a1     =  (ld_val_ls2_a2_q & ls2_page_split2_a1_q);


  assign pf_tlb_inject_v_ls2_i2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls2_i2_q & ~tmo_inject_val_ls2_i2   & ~spe_inject_val_ls2_i2 & ~tbe_inject_val_ls2_i2;
  assign pf_tlb_inject_v_ls2_a1    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls2_a1_q & ~tmo_inject_val_ls2_a1_q & ~spe_inject_val_ls2_a1_q & ~tbe_inject_val_ls2_a1_q;
  assign pf_tlb_inject_v_ls2_a2    = ~pf_debug_state & ~ls_drain & ~ls_spr_drain & address_inject_val_ls2_a2_q & ~tmo_inject_val_ls2_a2_q & ~spe_inject_val_ls2_a2_q & ~tbe_inject_val_ls2_a2_q;

  assign ls_is_uop_reject_ls2_d1   =  ls2_a1_reject_a1_q;

  assign any_issue_v_ls2_i2_a2 =  issue_v_ls2_i2_q
                                 | issue_ld_val_ls2_a1_q | issue_st_val_ls2_a1_q 
                                 |       ld_val_ls2_a2_q |       st_val_ls2_a2_q  
                                 | ls2_st_pf_on_rst_full_a1_q;

  assign any_issue_v_a1 = issue_ld_val_ls0_a1_q | issue_st_val_ls0_a1_q | unalign2_ls0_a1_q | pf_tlb_inject_v_ls0_a1
                        | issue_ld_val_ls1_a1_q | issue_st_val_ls1_a1_q | unalign2_ls1_a1_q | pf_tlb_inject_v_ls1_a1
                        | issue_ld_val_ls2_a1_q | issue_st_val_ls2_a1_q | unalign2_ls2_a1_q | pf_tlb_inject_v_ls2_a1
                        ;

  assign sb_addr_wr_poss_din = issue_v_ls0_i2_q & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q
                             | issue_v_ls1_i2_q & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q
                             | issue_st_val_ls0_a1_q
                             | issue_st_val_ls1_a1_q
                             | st_val_ls0_a2_q & unalign2_ls0_a1_q
                             | st_val_ls1_a2_q & unalign2_ls1_a1_q
                             | chka_disable_ls_rcg;




  assign addr_inject_outstanding_in =    ls_is_addr_inject_v
                                      | (addr_inject_outstanding_q & ~addr_injected_i2_qual);

  assign tmo_inject_outstanding_in =    ( tmo_injection_req_made                               )
                                      | ( tmo_inject_outstanding_q  & ~addr_injected_i2_qual   );


  assign spe_inject_outstanding_in =    ( spe_injection_req_made                               )
                                      | ( spe_inject_outstanding_q  & ~addr_injected_i2_qual   );

  assign spe_inject_val_a2   =   spe_inject_val_ls0_a2_q
                               | spe_inject_val_ls1_a2_q
                               | spe_inject_val_ls2_a2_q;

  assign tbe_inject_outstanding_in =    ( tbe_injection_req_made                               )
                                      | ( tbe_inject_outstanding_q  & ~addr_injected_i2_qual   );

  assign tbe_inject_val_a2   =   tbe_inject_val_ls0_a2_q
                               | tbe_inject_val_ls1_a2_q
                               | tbe_inject_val_ls2_a2_q;


  assign pref_addr_inject_outstanding =   ( addr_inject_outstanding_q   & ~tmo_inject_outstanding_q & ~spe_inject_outstanding_q & ~tbe_inject_outstanding_q) ; 


  assign inj_counter_en    = inj_counter_incr | inj_counter_clear;
  assign inj_counter_incr  = addr_inject_outstanding_q & ~addr_injected_i2_qual;
  assign inj_counter_clear = addr_injected_i2_qual;
  assign inject_cycle_counter_in[`RV_BC_LS_INJ_CNT_R] = inj_counter_incr  ? (inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R] + `RV_BC_LS_INJ_CNT_BITS'b1) :
                                                       inj_counter_clear ? {`RV_BC_LS_INJ_CNT_BITS{1'b0}}                       :
                                                                            inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R]         ;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_inject_cycle_counter_q_3_0
    if (reset_i == 1'b1)
      inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && inj_counter_en == 1'b1)
      inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R] <= `RV_BC_DFF_DELAY inject_cycle_counter_in[`RV_BC_LS_INJ_CNT_R];
    else if (reset_i == 1'b0 && inj_counter_en == 1'b0)
    begin
    end
    else
      inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (inj_counter_en == 1'b1)
      inject_cycle_counter_q[`RV_BC_LS_INJ_CNT_R] <= `RV_BC_DFF_DELAY inject_cycle_counter_in[`RV_BC_LS_INJ_CNT_R];
`endif
  end

  assign snp_inject_bubble_req = 
                                    ( inject_cycle_counter_q[3] | pref_injection_req_made | (snp_queue_full & tmo_injection_req_made)) & ~(|inject_cycle_counter_q[2:0]);

  assign ls0_snp_inject_bubble_req = (snp_inject_bubble_req | inject_iq_bubble_for_late_resolve) &  last_bubble_injected_ls1_q;
  assign ls1_snp_inject_bubble_req = (snp_inject_bubble_req | inject_iq_bubble_for_late_resolve) & ~last_bubble_injected_ls1_q;

  assign ls2_snp_inject_bubble_req = 1'b0;
  assign last_bubble_injected_ls1_in = flip_bubble_toggle ? ~last_bubble_injected_ls1_q : last_bubble_injected_ls1_q;
  assign flip_bubble_toggle          = snp_inject_bubble_req;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_last_bubble_injected_ls1_q
    if (reset_i == 1'b1)
      last_bubble_injected_ls1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      last_bubble_injected_ls1_q <= `RV_BC_DFF_DELAY last_bubble_injected_ls1_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      last_bubble_injected_ls1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      last_bubble_injected_ls1_q <= `RV_BC_DFF_DELAY last_bubble_injected_ls1_in;
`endif
  end


  assign addr_inject_en =     ls_is_addr_inject_v 
                            | addr_inject_outstanding_q 
                            | address_inject_val_ls0_i2_q | address_inject_val_ls1_i2_q | address_inject_val_ls2_i2_q
                            | address_inject_val_ls0_a1_q | address_inject_val_ls1_a1_q | address_inject_val_ls2_a1_q
                            | address_inject_val_ls0_a2_q | address_inject_val_ls1_a2_q | address_inject_val_ls2_a2_q
                            | any_snp_tmo_req
                            | pf_tlb_lookup_req_q
                            | pf_tlb_lookup_req_skid_q
                            | spe_tlb_lookup_req
                            | tbe_tlb_lookup_req
                            | flip_bubble_toggle;


 
  assign pf_tlb_lookup_req_skid_in =    ( pf_tlb_lookup_req_q & ~pf_tlb_lookup_req_skid_q & ~pref_byp_injection_req_made   & ~pf_tlb_lookup_drop)
                                      | (                        pf_tlb_lookup_req_skid_q & ~pref_skid_injection_req_made  & ~pf_tlb_lookup_drop);


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_req_skid_q
    if (reset_i == 1'b1)
      pf_tlb_lookup_req_skid_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      pf_tlb_lookup_req_skid_q <= `RV_BC_DFF_DELAY pf_tlb_lookup_req_skid_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_req_skid_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      pf_tlb_lookup_req_skid_q <= `RV_BC_DFF_DELAY pf_tlb_lookup_req_skid_in;
`endif
  end


  assign pf_tlb_skid_en = pf_tlb_lookup_req_q & ~pf_tlb_lookup_req_skid_q;

  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_va_skid_q_48_12
    if (reset_i == 1'b1)
      pf_tlb_lookup_va_skid_q[`RV_BC_LS_VA_MAX:12] <= `RV_BC_DFF_DELAY {37{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pf_tlb_skid_en == 1'b1)
      pf_tlb_lookup_va_skid_q[`RV_BC_LS_VA_MAX:12] <= `RV_BC_DFF_DELAY pf_tlb_lookup_va_q[`RV_BC_LS_VA_MAX:12];
    else if (reset_i == 1'b0 && pf_tlb_skid_en == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_va_skid_q[`RV_BC_LS_VA_MAX:12] <= `RV_BC_DFF_DELAY {37{1'bx}};
`else
    else if (pf_tlb_skid_en == 1'b1)
      pf_tlb_lookup_va_skid_q[`RV_BC_LS_VA_MAX:12] <= `RV_BC_DFF_DELAY pf_tlb_lookup_va_q[`RV_BC_LS_VA_MAX:12];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_id_skid_q_3_0
    if (reset_i == 1'b1)
      pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pf_tlb_skid_en == 1'b1)
      pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_id_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
    else if (reset_i == 1'b0 && pf_tlb_skid_en == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (pf_tlb_skid_en == 1'b1)
      pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_id_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
`endif
  end



  assign pf_tlb_lookup_injected_i2 = pref_addr_inject_outstanding & addr_injected_i2_qual;
  assign pf_tlb_lookup_injected_a1 =      pf_tlb_inject_v_ls0_a1
                                        | pf_tlb_inject_v_ls1_a1
                                        | pf_tlb_inject_v_ls2_a1
                                        ;



  assign pf_tlb_lookup_injected_id_outstanding_in[`RV_BC_LS_PF_GT_TLB_ID_R] = pref_skid_injection_req_made ? pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GT_TLB_ID_R] : pf_tlb_lookup_id_q[`RV_BC_LS_PF_GT_TLB_ID_R];

  assign pf_tlb_lookup_outstanding_en = pref_injection_req_made;

  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_injected_id_outstanding_q_3_0
    if (reset_i == 1'b1)
      pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pf_tlb_lookup_outstanding_en == 1'b1)
      pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_outstanding_in[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
    else if (reset_i == 1'b0 && pf_tlb_lookup_outstanding_en == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (pf_tlb_lookup_outstanding_en == 1'b1)
      pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_outstanding_in[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_injected_id_a1_q_3_0
    if (reset_i == 1'b1)
      pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pf_tlb_lookup_injected_i2 == 1'b1)
      pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
    else if (reset_i == 1'b0 && pf_tlb_lookup_injected_i2 == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (pf_tlb_lookup_injected_i2 == 1'b1)
      pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_outstanding_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pf_tlb_lookup_injected_id_a2_q_3_0
    if (reset_i == 1'b1)
      pf_tlb_lookup_injected_id_a2_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pf_tlb_lookup_injected_a1 == 1'b1)
      pf_tlb_lookup_injected_id_a2_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
    else if (reset_i == 1'b0 && pf_tlb_lookup_injected_a1 == 1'b0)
    begin
    end
    else
      pf_tlb_lookup_injected_id_a2_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (pf_tlb_lookup_injected_a1 == 1'b1)
      pf_tlb_lookup_injected_id_a2_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0] <= `RV_BC_DFF_DELAY pf_tlb_lookup_injected_id_a1_q[`RV_BC_LS_PF_GEN_TLB_ID_MAX:0];
`endif
  end




  always_ff @(posedge clk or posedge reset_i)
  begin: u_addr_inject_outstanding_q
    if (reset_i == 1'b1)
      addr_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      addr_inject_outstanding_q <= `RV_BC_DFF_DELAY addr_inject_outstanding_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      addr_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      addr_inject_outstanding_q <= `RV_BC_DFF_DELAY addr_inject_outstanding_in;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_inject_outstanding_q
    if (reset_i == 1'b1)
      tmo_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tmo_inject_outstanding_q <= `RV_BC_DFF_DELAY tmo_inject_outstanding_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tmo_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tmo_inject_outstanding_q <= `RV_BC_DFF_DELAY tmo_inject_outstanding_in;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_inject_outstanding_q
    if (reset_i == 1'b1)
      spe_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      spe_inject_outstanding_q <= `RV_BC_DFF_DELAY spe_inject_outstanding_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      spe_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      spe_inject_outstanding_q <= `RV_BC_DFF_DELAY spe_inject_outstanding_in;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_inject_outstanding_q
    if (reset_i == 1'b1)
      tbe_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      tbe_inject_outstanding_q <= `RV_BC_DFF_DELAY tbe_inject_outstanding_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      tbe_inject_outstanding_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      tbe_inject_outstanding_q <= `RV_BC_DFF_DELAY tbe_inject_outstanding_in;
`endif
  end






  assign pf_tlb_lookup_drop                             = pf_debug_state | ls_drain | ls_spr_drain | snp_sync_in_progress | wayt_ct_tofu_vld_q | clr_all_gen_entries_q;

  assign pf_accepted_tlb_lookup_drop                             = pf_tlb_lookup_req_skid_q & pf_tlb_lookup_drop;
  assign pf_accepted_tlb_lookup_drop_id[`RV_BC_LS_PF_GT_TLB_ID_R] = pf_tlb_lookup_id_skid_q[`RV_BC_LS_PF_GT_TLB_ID_R];

  assign pref_injection_req                 = pf_tlb_lookup_req_q      & ~pref_addr_inject_outstanding & ~pf_tlb_lookup_drop; 
  assign pref_skid_injection_req            = pf_tlb_lookup_req_skid_q & ~pref_addr_inject_outstanding & ~pf_tlb_lookup_drop; 

  assign tmo_injection_req_qual             = any_snp_tmo_req         &  ~tmo_req_suppress_m0;
  assign pref_skid_injection_req_qual       = pref_skid_injection_req & ~pref_req_suppress_m0;
  assign pref_injection_req_qual            = pref_injection_req      & ~pref_req_suppress_m0;
  assign spe_injection_req_qual             = spe_tlb_lookup_req      &  ~spe_req_suppress_m0;
  assign tbe_injection_req_qual             = tbe_tlb_lookup_req      &  ~tbe_req_suppress_m0;

  assign injection_sel_tmo                  =   tmo_injection_req_qual;                                                                                         
  assign injection_sel_pref_skid            =  ~tmo_injection_req_qual  &  pref_skid_injection_req_qual;                                                        
  assign injection_sel_pref                 =  ~tmo_injection_req_qual  & ~pref_skid_injection_req_qual &  pref_injection_req_qual;                             
  assign injection_sel_spe                  =  ~tmo_injection_req_qual  & ~pref_skid_injection_req_qual & ~pref_injection_req_qual  & spe_injection_req_qual;  
  assign injection_sel_tbe                  =  ~tmo_injection_req_qual  & ~pref_skid_injection_req_qual & ~pref_injection_req_qual  & ~spe_injection_req_qual & tbe_injection_req_qual;  


  assign tmo_injection_req_made             = ready_to_inject_addr & injection_sel_tmo ;
  assign pref_byp_injection_req_made        = ready_to_inject_addr & injection_sel_pref;  
  assign pref_skid_injection_req_made       = ready_to_inject_addr & injection_sel_pref_skid;  
  assign spe_injection_req_made             = ready_to_inject_addr & injection_sel_spe;  
  assign tbe_injection_req_made             = ready_to_inject_addr & injection_sel_tbe; 

  assign pref_injection_req_made = pref_byp_injection_req_made | pref_skid_injection_req_made;

  assign pf_tlb_lookup_req_accepted =  ~pf_tlb_lookup_req_skid_q & ~pf_tlb_lookup_drop; 


  assign toggle_favors_tmo_in              =    ( 
                                                    spe_injection_req_made                                  
                                                  | tbe_injection_req_made
                                                  | toggle_favors_tmo_q                                     
                                                )
                                             & ~tmo_injection_req_made;                                     


  always_ff @(posedge clk or posedge reset_i)
  begin: u_toggle_favors_tmo_q
    if (reset_i == 1'b1)
      toggle_favors_tmo_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && addr_inject_en == 1'b1)
      toggle_favors_tmo_q <= `RV_BC_DFF_DELAY toggle_favors_tmo_in;
    else if (reset_i == 1'b0 && addr_inject_en == 1'b0)
    begin
    end
    else
      toggle_favors_tmo_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (addr_inject_en == 1'b1)
      toggle_favors_tmo_q <= `RV_BC_DFF_DELAY toggle_favors_tmo_in;
`endif
  end


  assign ready_to_inject_addr     = ~addr_inject_outstanding_q ;
  assign ls_is_addr_inject_v      = tmo_injection_req_made | pref_injection_req_made | spe_injection_req_made | tbe_injection_req_made;
  assign ls_is_addr_inject[`RV_BC_LS_VA_MAX:12] =     ( {(`RV_BC_LS_VA_MAX-12+1){injection_sel_tmo}}       &        snp_tmo_req_addr[`RV_BC_LS_VA_MAX:12] )
                                                   | ( {(`RV_BC_LS_VA_MAX-12+1){injection_sel_pref}}      &      pf_tlb_lookup_va_q[`RV_BC_LS_VA_MAX:12] )
                                                   | ( {(`RV_BC_LS_VA_MAX-12+1){injection_sel_pref_skid}} & pf_tlb_lookup_va_skid_q[`RV_BC_LS_VA_MAX:12] )
                                                   | ( {(`RV_BC_LS_VA_MAX-12+1){injection_sel_tbe}}       &   tbe_tlb_lookup_req_va[`RV_BC_LS_VA_MAX:12] )
                                                   | ( {(`RV_BC_LS_VA_MAX-12+1){injection_sel_spe}}       &   spe_tlb_lookup_req_va[`RV_BC_LS_VA_MAX:12] );




  assign addr_injected_i2_qual =    address_inject_val_ls0_i2_q
                                  | address_inject_val_ls1_i2_q
                                  | address_inject_val_ls2_i2_q;

  assign tmo_req_done_i2                      =  tmo_inject_outstanding_q & addr_injected_i2_qual;


  assign      possible_req_cnt_incr =     any_snp_tmo_req                                   
                                      |   pf_tlb_lookup_req_q                          
                                      |   spe_tlb_lookup_req   
                                      |   tbe_tlb_lookup_req
                                      | precommit_reject_saturated;


  assign   tmo_req_waiting_cnt_incr = any_snp_tmo_req                                  &   ~tmo_req_waiting_cnt_saturated;
  assign  pref_req_waiting_cnt_incr = pref_skid_injection_req                          &   ~pref_req_waiting_cnt_saturated;
  assign   spe_req_waiting_cnt_incr = spe_tlb_lookup_req                               &   ~spe_req_waiting_cnt_saturated;
  assign   tbe_req_waiting_cnt_incr = tbe_tlb_lookup_req                               &   ~tbe_req_waiting_cnt_saturated;

  assign   tmo_req_waiting_cnt_clear =       tmo_injection_req_made | ~any_snp_tmo_req                                ;
  assign  pref_req_waiting_cnt_clear = pref_skid_injection_req_made | ~pref_skid_injection_req                        ;
  assign   spe_req_waiting_cnt_clear =       spe_injection_req_made | ~spe_tlb_lookup_req                             ;
  assign   tbe_req_waiting_cnt_clear =       tbe_injection_req_made | ~tbe_tlb_lookup_req                             ;


  assign   tmo_req_waiting_cnt_saturated =   &tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R];
  assign  pref_req_waiting_cnt_saturated =  &pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R];
  assign   spe_req_waiting_cnt_saturated =   &spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R];
  assign   tbe_req_waiting_cnt_saturated =   &tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R];

  assign   tmo_req_waiting_cnt_saturated_nxt =   &tmo_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
  assign  pref_req_waiting_cnt_saturated_nxt =  &pref_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
  assign   spe_req_waiting_cnt_saturated_nxt =   &spe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
  assign   tbe_req_waiting_cnt_saturated_nxt =   &tbe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];

  assign any_req_waiting_cnt_saturated_in =   
                                             tmo_req_waiting_cnt_saturated_nxt
                                         |  pref_req_waiting_cnt_saturated_nxt
                                         |   spe_req_waiting_cnt_saturated_nxt 
                                         |   tbe_req_waiting_cnt_saturated_nxt ; 

  assign      tmo_req_suppress_m0 = ( (any_req_waiting_cnt_saturated_q & ~round_robin_select_q[`RV_BC_LS_INJ_RR_TMO] ) | precommit_reject_saturated ) & ~(ls_16_of_64_tick_tock & (~(spe_tlb_lookup_req | tbe_tlb_lookup_req) |  toggle_favors_tmo_q));  
  assign     pref_req_suppress_m0 = ( (any_req_waiting_cnt_saturated_q & ~round_robin_select_q[`RV_BC_LS_INJ_RR_PREF]) | precommit_reject_saturated )                                                                          ;
  assign      spe_req_suppress_m0 = ( (any_req_waiting_cnt_saturated_q & ~round_robin_select_q[`RV_BC_LS_INJ_RR_SPE] ) | precommit_reject_saturated ) & ~(ls_16_of_64_tick_tock & (~any_snp_tmo_req    | ~toggle_favors_tmo_q));  
  assign      tbe_req_suppress_m0 = ( (any_req_waiting_cnt_saturated_q & ~round_robin_select_q[`RV_BC_LS_INJ_RR_TBE] ) | precommit_reject_saturated ) & ~(ls_16_of_64_tick_tock & (~any_snp_tmo_req    | ~toggle_favors_tmo_q));

  assign req_waiting_cnt_saturated_bundle[`RV_BC_LS_INJ_RR_TMO]   =   tmo_req_waiting_cnt_saturated_nxt;
  assign req_waiting_cnt_saturated_bundle[`RV_BC_LS_INJ_RR_PREF]  =  pref_req_waiting_cnt_saturated_nxt;
  assign req_waiting_cnt_saturated_bundle[`RV_BC_LS_INJ_RR_SPE]   =   spe_req_waiting_cnt_saturated_nxt;
  assign req_waiting_cnt_saturated_bundle[`RV_BC_LS_INJ_RR_TBE]   =   tbe_req_waiting_cnt_saturated_nxt;



generate
  for (src=0; src<`RV_BC_LS_INJ_RR_SOURCES-1; src=src+1) begin : rr_mask_gen
    assign rr_mask[src] = |round_robin_select_q[`RV_BC_LS_INJ_RR_SOURCES-1:src+1]; 
  end
endgenerate
  assign rr_mask[`RV_BC_LS_INJ_RR_SOURCES-1] = 1'b0;

  assign req_waiting_cnt_saturated_bundle_masked[`RV_BC_LS_INJ_RR_SOURCES-1:0] = req_waiting_cnt_saturated_bundle[`RV_BC_LS_INJ_RR_SOURCES-1:0] & ~rr_mask[`RV_BC_LS_INJ_RR_SOURCES-1:0];

  assign rr_find_first_masked[0] = req_waiting_cnt_saturated_bundle_masked[0];
generate
  for (src=1; src<`RV_BC_LS_INJ_RR_SOURCES; src=src+1) begin : rr_find_first_masked_gen
    assign rr_find_first_masked[src] = req_waiting_cnt_saturated_bundle_masked[src] & ~(|req_waiting_cnt_saturated_bundle_masked[src-1:0]);
  end
endgenerate

  assign rr_find_first[0] = req_waiting_cnt_saturated_bundle[0];
generate
  for (src=1; src<`RV_BC_LS_INJ_RR_SOURCES; src=src+1) begin : rr_find_first_gen
    assign rr_find_first[src] = req_waiting_cnt_saturated_bundle[src] & ~(|req_waiting_cnt_saturated_bundle[src-1:0]);
  end
endgenerate

  assign any_rr_find_first_masked = |rr_find_first_masked[`RV_BC_LS_INJ_RR_SOURCES-1:0];
  assign any_rr_find_first        =        |rr_find_first[`RV_BC_LS_INJ_RR_SOURCES-1:0];
  assign round_robin_select_in[`RV_BC_LS_INJ_RR_SOURCES-1:0] = any_rr_find_first_masked ? rr_find_first_masked[`RV_BC_LS_INJ_RR_SOURCES-1:0] :
                                                              any_rr_find_first        ?        rr_find_first[`RV_BC_LS_INJ_RR_SOURCES-1:0] :
                                                                                         round_robin_select_q[`RV_BC_LS_INJ_RR_SOURCES-1:0] ;


  assign tmo_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R] = 
                                       tmo_req_waiting_cnt_clear ? ({`RV_BC_LS_INJ_COUNT_WIDTH{1'b0}})                                           : 
                                       tmo_req_waiting_cnt_incr  ? (tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] + `RV_BC_LS_INJ_COUNT_WIDTH'b1)  : 
                                                                   (tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R])                                ; 

  assign pref_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R] = 
                                       pref_req_waiting_cnt_clear ? ({`RV_BC_LS_INJ_COUNT_WIDTH{1'b0}})                                            : 
                                       pref_req_waiting_cnt_incr  ? (pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] + `RV_BC_LS_INJ_COUNT_WIDTH'b1)  : 
                                                                    (pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R])                                ; 

  assign spe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R] = 
                                       spe_req_waiting_cnt_clear ? ({`RV_BC_LS_INJ_COUNT_WIDTH{1'b0}})                                           : 
                                       spe_req_waiting_cnt_incr  ? (spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] + `RV_BC_LS_INJ_COUNT_WIDTH'b1)  : 
                                                                   (spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R])                                ; 

  assign tbe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R] = 
                                       tbe_req_waiting_cnt_clear ? ({`RV_BC_LS_INJ_COUNT_WIDTH{1'b0}})                                           : 
                                       tbe_req_waiting_cnt_incr  ? (tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] + `RV_BC_LS_INJ_COUNT_WIDTH'b1)  : 
                                                                   (tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R])                                ; 


  assign   tmo_req_waiting_cnt_en =   tmo_req_waiting_cnt_incr   |   tmo_req_waiting_cnt_clear;
  assign  pref_req_waiting_cnt_en =  pref_req_waiting_cnt_incr   |  pref_req_waiting_cnt_clear;
  assign   spe_req_waiting_cnt_en =   spe_req_waiting_cnt_incr   |   spe_req_waiting_cnt_clear;
  assign   tbe_req_waiting_cnt_en =   tbe_req_waiting_cnt_incr   |   tbe_req_waiting_cnt_clear;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tmo_req_waiting_cnt_q_3_0
    if (reset_i == 1'b1)
      tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && tmo_req_waiting_cnt_en == 1'b1)
      tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY tmo_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
    else if (reset_i == 1'b0 && tmo_req_waiting_cnt_en == 1'b0)
    begin
    end
    else
      tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (tmo_req_waiting_cnt_en == 1'b1)
      tmo_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY tmo_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_pref_req_waiting_cnt_q_3_0
    if (reset_i == 1'b1)
      pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && pref_req_waiting_cnt_en == 1'b1)
      pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY pref_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
    else if (reset_i == 1'b0 && pref_req_waiting_cnt_en == 1'b0)
    begin
    end
    else
      pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (pref_req_waiting_cnt_en == 1'b1)
      pref_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY pref_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_spe_req_waiting_cnt_q_3_0
    if (reset_i == 1'b1)
      spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && spe_req_waiting_cnt_en == 1'b1)
      spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY spe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
    else if (reset_i == 1'b0 && spe_req_waiting_cnt_en == 1'b0)
    begin
    end
    else
      spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (spe_req_waiting_cnt_en == 1'b1)
      spe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY spe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_tbe_req_waiting_cnt_q_3_0
    if (reset_i == 1'b1)
      tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && tbe_req_waiting_cnt_en == 1'b1)
      tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY tbe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
    else if (reset_i == 1'b0 && tbe_req_waiting_cnt_en == 1'b0)
    begin
    end
    else
      tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (tbe_req_waiting_cnt_en == 1'b1)
      tbe_req_waiting_cnt_q[`RV_BC_LS_INJ_COUNT_R] <= `RV_BC_DFF_DELAY tbe_req_waiting_cnt_in[`RV_BC_LS_INJ_COUNT_R];
`endif
  end



  assign req_waiting_en =   possible_req_cnt_incr
                          | any_req_waiting_cnt_saturated_q;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_any_req_waiting_cnt_saturated_q
    if (reset_i == 1'b1)
      any_req_waiting_cnt_saturated_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && req_waiting_en == 1'b1)
      any_req_waiting_cnt_saturated_q <= `RV_BC_DFF_DELAY any_req_waiting_cnt_saturated_in;
    else if (reset_i == 1'b0 && req_waiting_en == 1'b0)
    begin
    end
    else
      any_req_waiting_cnt_saturated_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (req_waiting_en == 1'b1)
      any_req_waiting_cnt_saturated_q <= `RV_BC_DFF_DELAY any_req_waiting_cnt_saturated_in;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_round_robin_select_q_4_1_1
    if (reset_i == 1'b1)
      round_robin_select_q[(`RV_BC_LS_INJ_RR_SOURCES-1):1] <= `RV_BC_DFF_DELAY {3{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && req_waiting_en == 1'b1)
      round_robin_select_q[(`RV_BC_LS_INJ_RR_SOURCES-1):1] <= `RV_BC_DFF_DELAY round_robin_select_in[(`RV_BC_LS_INJ_RR_SOURCES-1):1];
    else if (reset_i == 1'b0 && req_waiting_en == 1'b0)
    begin
    end
    else
      round_robin_select_q[(`RV_BC_LS_INJ_RR_SOURCES-1):1] <= `RV_BC_DFF_DELAY {3{1'bx}};
`else
    else if (req_waiting_en == 1'b1)
      round_robin_select_q[(`RV_BC_LS_INJ_RR_SOURCES-1):1] <= `RV_BC_DFF_DELAY round_robin_select_in[(`RV_BC_LS_INJ_RR_SOURCES-1):1];
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_round_robin_select_q_0
    if (reset_i == 1'b1)
      round_robin_select_q[0] <= `RV_BC_DFF_DELAY {1{1'b1}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && req_waiting_en == 1'b1)
      round_robin_select_q[0] <= `RV_BC_DFF_DELAY round_robin_select_in[0];
    else if (reset_i == 1'b0 && req_waiting_en == 1'b0)
    begin
    end
    else
      round_robin_select_q[0] <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (req_waiting_en == 1'b1)
      round_robin_select_q[0] <= `RV_BC_DFF_DELAY round_robin_select_in[0];
`endif
  end







  assign any_issue_v_i2_a2 = any_issue_v_ls0_i2_a2 | any_issue_v_ls1_i2_a2 | any_issue_v_ls2_i2_a2;


  always_ff @(posedge clk)
  begin: u_ls0_uop_older_than_ls1_a1_q
    if (any_issue_v_i2_a2 == 1'b1)
      ls0_uop_older_than_ls1_a1_q <= `RV_BC_DFF_DELAY ls0_uop_older_than_ls1_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_uop_older_than_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls0_uop_older_than_ls2_a1_q
    if (any_issue_v_i2_a2 == 1'b1)
      ls0_uop_older_than_ls2_a1_q <= `RV_BC_DFF_DELAY ls0_uop_older_than_ls2_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_uop_older_than_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls1_uop_older_than_ls2_a1_q
    if (any_issue_v_i2_a2 == 1'b1)
      ls1_uop_older_than_ls2_a1_q <= `RV_BC_DFF_DELAY ls1_uop_older_than_ls2_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_uop_older_than_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  always_ff @(posedge clk)
  begin: u_ls0_uop_older_than_ls1_a2_q
    if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls0_uop_older_than_ls1_a2_q <= `RV_BC_DFF_DELAY ls0_uop_older_than_ls1_a1_q;
`ifdef RV_BC_XPROP_FLOP
    else if (any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_uop_older_than_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end




  
  assign ls_ctl_format_ls0_i2 = ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] 
                                  & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls0_i2_q[4:3])
                                  & ~(ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                         
                                  & ((~(&ls_uop_ctl_ls0_i2_q[3:2]) | ~(|ls_uop_ctl_ls0_i2_q[1:0])) | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  assign ls_ctl_format_ls0_a1 = st_val_ls0_a1 & ~ls_uop_ctl_ls0_a1_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls0_a1_q[4:3]) 
                                  & ~(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                          
                                  & ((~(&ls_uop_ctl_ls0_a1_q[3:2]) | ~(|ls_uop_ctl_ls0_a1_q[1:0])) | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  always_comb 
  begin: u_uop_size_dec1_raw_ls0_i2_4_0
    casez({ls_ctl_format_ls0_i2, ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_T_SIZE]})
      {1'b1, 3'b???}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_B}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_H}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b00001;  
      {1'b0, `RV_BC_SIZE_W}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b00011;  
      {1'b0, `RV_BC_SIZE_D}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b00111;  
      {1'b0, `RV_BC_SIZE_16}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b01111;  
      {1'b0, `RV_BC_SIZE_32}: uop_size_dec1_raw_ls0_i2[4:0] = 5'b11111;  
      default: uop_size_dec1_raw_ls0_i2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls_ctl_format_ls0_i2, ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_T_SIZE]})) === 1'bx)
      uop_size_dec1_raw_ls0_i2[4:0] = {5{1'bx}};
`endif
  end


  assign ls0_pf_trainable_type_a1 = ( st_val_ls0_a1 & ( (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_ST)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STTR)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STNP)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STLR)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST2)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST3)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST4)
                                                          )
                                      | ld_val_ls0_a1 & ( (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDAR)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDTR)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDNP)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                                          | ((ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_LD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3)
                                                          | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4)
                                                          ));


  assign issue_ld_val_ls0_i2            = issue_v_ls0_i2   & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q;

  assign issue_ld_val_possible_ls0_i2   = issue_v_ls0_i2_q & ~is_ls_issue_cancel_ls0_i2   & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q;

  assign issue_pld_val_possible_ls0_i2  =    issue_ld_val_possible_ls0_i2
                                            & (
                                                  (ls_uop_ctl_ls0_i2_q[5:4] == 2'b01) 
                                                | (ls_uop_ctl_ls0_i2_q[5:3] == 3'b100)
                                              );

  assign issue_ld_val_early_ls0_i2      = issue_v_early_ls0_i2   & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q;


  assign issue_st_val_ls0_i2            = issue_v_ls0_i2_q &  ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q & ~unalign2_ls0_i2;
  assign issue_st_val_ls0_a1_din        = issue_v_ls0_i2   &  ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q;

  assign issue_ld_val_ls0_a1            = issue_ld_val_ls0_a1_q & ~ls_is_uop_reject_ls0_d1;
  assign issue_st_val_ls0_a1            = issue_st_val_ls0_a1_q;

  assign ld_val_ls0_a1          = unalign2_dup_ls0_a1_q ? ld_val_ls0_a2_q 
                                                            : issue_ld_val_ls0_a1;

  assign st_val_ls0_a1          = unalign2_ls0_a1_q ? st_val_ls0_a2_q
                                                        : issue_st_val_ls0_a1;

  assign tlb_cam_v_ld_st_ccpass_ls0_a1          =   pf_tlb_inject_v_ls0_a1                                           
                                                    | spe_inject_val_ls0_a1_q                                          
                                                    | tbe_inject_val_ls0_a1_q                                          
                                                    | (  (   ld_val_ls0_a1                                             
                                                           | (st_val_ls0_a1 & ~st_no_xlat_ls0_a1)                    
                                                         )
                                                       & ccpass_ls0_a1                                                 
                                                       & (~unalign2_ls0_a1_q | ls0_page_split2_a1_q)                   
                                                      ) ;

  assign va_v_ld_st_ccpass_ls0_a1               =   pf_tlb_inject_v_ls0_a1                                           
                                                    | spe_inject_val_ls0_a1_q                                          
                                                    | tbe_inject_val_ls0_a1_q                                          
                                                    | (  (   ld_val_ls0_a1                                             
                                                           | (st_val_ls0_a1 & ~st_no_xlat_ls0_a1)                    
                                                         )
                                                       & ccpass_ls0_a1                                                 

                                                      ) ;
     
  assign tlb_cam_v_ls0_a1                       = tlb_cam_v_ld_st_ccpass_ls0_a1 | address_inject_val_ls0_a1_q ;                                     
  assign va_v_ls0_a1                            = va_v_ld_st_ccpass_ls0_a1      | address_inject_val_ls0_a1_q ;                                     

  assign agu_addend_a_ls0_i2[31:0]  = {32{ unalign2_ls0_i2                           }} & va_ls0_a1[31:0]
                                      | {32{~unalign2_ls0_i2 & is_ls_srca_v_ls0_i2[0]}} & is_ls_srca_data_ls0_i2[31:0];

  assign agu_addend_a_ls0_i2[63:32] = {32{ unalign2_ls0_i2                                                                                                 }} & va_ls0_a1[63:32]
                                      | {32{~unalign2_ls0_i2 & is_ls_srca_v_ls0_i2[1] & (~cpsr_aarch32 | tmo_inject_val_ls0_i2 | spe_inject_val_ls0_i2 | tbe_inject_val_ls0_i2)}} & is_ls_srca_data_ls0_i2[63:32];


  assign srcb_sel_no_shift_ls0_i2   =   is_ls_srcb_v_ls0_i2[0] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_NO_SH)    & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;
  assign srcb_sel_shift1_ls0_i2     =   is_ls_srcb_v_ls0_i2[0] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH1)      & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;  
  assign srcb_sel_shift2_ls0_i2     =   is_ls_srcb_v_ls0_i2[0] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH2)      & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;
  assign srcb_sel_shift3_ls0_i2     =   is_ls_srcb_v_ls0_i2[0] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH3)      & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;

  assign srcb_sel_no_ext_ls0_i2     =                            ( (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_NO_EXT)
                                                                   | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)) & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;

  assign srcb_sel_sext_ls0_i2       =   is_ls_srcb_v_ls0_i2[0] & (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_SEXT)     & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;

  assign carry_in_ls0_i2            =                              (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)  & ~unalign2_ls0_i2 & ~address_inject_val_ls0_i2_q;



  assign ls0_32byte_ld_st_cache_line_split_2nd_half_a1 = (ls0_fast_va_a1[5:4] != 2'b11 ) & uop_size_dec1_raw_ls0_a1_q[4] ; 
  assign unalign2_src_b_ls0_i2[31:0] = issue_st_val_ls0_a1_q & ls0_32byte_ld_st_cache_line_split_2nd_half_a1 ?  32'h20 : 32'h10 ; 

  assign agu_addend_b_ls0_i2[31:0]  = {32{unalign2_ls0_i2}}          & unalign2_src_b_ls0_i2[31:0] 
                                      | {32{srcb_sel_no_shift_ls0_i2}} &  is_ls_srcb_data_ls0_i2[31:0]
                                      | {32{srcb_sel_shift1_ls0_i2}}   & {is_ls_srcb_data_ls0_i2[30:0], 1'b0}
                                      | {32{srcb_sel_shift2_ls0_i2}}   & {is_ls_srcb_data_ls0_i2[29:0], 2'b0}
                                      | {32{srcb_sel_shift3_ls0_i2}}   & {is_ls_srcb_data_ls0_i2[28:0], 3'b0};

  assign agu_addend_b_ls0_i2[32]    =     srcb_sel_no_shift_ls0_i2   &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[32]
                                      |     srcb_sel_no_shift_ls0_i2   &  srcb_sel_sext_ls0_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift1_ls0_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift2_ls0_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[30]
                                      |     srcb_sel_shift3_ls0_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[29];

  assign agu_addend_b_ls0_i2[33]    =     srcb_sel_no_shift_ls0_i2   &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[33]
                                      |     srcb_sel_no_shift_ls0_i2   &  srcb_sel_sext_ls0_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift1_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[32]
                                      |     srcb_sel_shift1_ls0_i2     &  srcb_sel_sext_ls0_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift2_ls0_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift3_ls0_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[30];

  assign agu_addend_b_ls0_i2[34]    =     srcb_sel_no_shift_ls0_i2   &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[34]
                                      |    (srcb_sel_shift3_ls0_i2     |  srcb_sel_sext_ls0_i2)  & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[31]
                                      |     srcb_sel_shift2_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[32]
                                      |     srcb_sel_shift1_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]   & is_ls_srcb_data_ls0_i2[33];

  assign agu_addend_b_ls0_i2[63:35] = {29{srcb_sel_no_shift_ls0_i2   &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]}} & is_ls_srcb_data_ls0_i2[63:35]
                                      | {29{srcb_sel_shift1_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]}} & is_ls_srcb_data_ls0_i2[62:34]
                                      | {29{srcb_sel_shift2_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]}} & is_ls_srcb_data_ls0_i2[61:33]
                                      | {29{srcb_sel_shift3_ls0_i2     &  srcb_sel_no_ext_ls0_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls0_i2[1]}} & is_ls_srcb_data_ls0_i2[60:32]
                                      |                                 {29{srcb_sel_sext_ls0_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls0_i2[   31]}};

  assign srcb_eq_zero_ls0_i2[0] = ~unalign2_ls0_i2 & ~is_ls_srcb_v_ls0_i2[0] & ~carry_in_ls0_i2 
                                  | address_inject_val_ls0_i2_q;

  assign srcb_eq_zero_ls0_i2[1] = ~( is_ls_srcb_v_ls0_i2[1]
                                     | is_ls_srcb_v_ls0_i2[0] & srcb_sel_sext_ls0_i2 & is_ls_srcb_data_ls0_i2[31])    
                                  |  unalign2_ls0_i2 
                                  |  address_inject_val_ls0_i2_q
                                  |  cpsr_aarch32;

  assign srca_hi_eq_zero_ls0_i2 = ~(is_ls_srca_v_ls0_i2[1] | unalign2_ls0_i2) 
                                  |  (cpsr_aarch32 & ~address_inject_val_ls0_i2_q);

  assign srca_v_ls0_i2          = is_ls_srca_v_ls0_i2[0] | unalign2_ls0_i2;

  assign agu_addend_a_en_ls0_i2[0] = (   issue_v_ls0_i2_q
                                        &  (  is_ls_srca_v_ls0_i2[0]
                                             | invdbg_ok                                      
                                           )
                                       )
                                     |  unalign2_ls0_i2;


  assign agu_addend_a_en_ls0_i2[1] = ( issue_v_ls0_i2_q
                                       &  (  is_ls_srca_v_ls0_i2[1]
                                          | ~srca_hi_eq_zero_ls0_a1_q))                       
                                     |  unalign2_ls0_i2;

  assign agu_addend_b_en_ls0_i2[0] = ( issue_v_ls0_i2_q
                                       &  (  is_ls_srcb_v_ls0_i2[0]
                                          |  carry_in_ls0_i2
                                          | ~srcb_eq_zero_ls0_a1_q[0]                        
                                          | invdbg_ok                                           
                                          )
                                        )
                                     |  unalign2_ls0_i2;

  assign agu_addend_b_en_ls0_i2[1] = ( issue_v_ls0_i2_q
                                       &  (  is_ls_srcb_v_ls0_i2[1]
                                          |  is_ls_srcb_v_ls0_i2[0] & srcb_sel_sext_ls0_i2 
                                          |  issue_cancel_ls0_i2_dly_q                       
                                          | ~srcb_eq_zero_ls0_a1_q[1]))                      
                                     |  unalign2_ls0_i2;


  assign st_pf_vld_ls0_i2 = ~address_inject_val_ls0_i2_q & ~(
                             | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_TYPE_ATOMIC] )
                             | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STREX )
                             | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] ==  `RV_BC_LS_TYPE_STLXR )
                             | ls_ctl_format_ls0_i2); 



  assign agu_addend_a_dup_en_ls0_i2 = ( issue_v_ls0_i2_q & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q & ~unalign2_ls0_i2
                                        &  (  is_ls_srca_v_ls0_i2[0]))                       
                                      | (unalign2_ls0_i2 & issue_ld_val_ls0_a1)
                                      | ((issue_v_ls0_i2_q | unalign2_ls0_i2) & (invdbg_ok |                         
                                                                                     rst_full_ls0_q & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls0_i2));     
  assign agu_addend_b_dup_en_ls0_i2 = ( issue_v_ls0_i2_q & ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls0_i2_q & ~unalign2_ls0_i2
                                        &  (  is_ls_srcb_v_ls0_i2[0]
                                           |  carry_in_ls0_i2
                                           | ~srcb_eq_zero_dup_ls0_a1_q))                        
                                      | (unalign2_ls0_i2 & issue_ld_val_ls0_a1)
                                      | ((issue_v_ls0_i2_q | unalign2_ls0_i2) & (invdbg_ok | 
                                                                                      rst_full_ls0_q & ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls0_i2));     


  always_ff @(posedge clk_agu0)
  begin: u_uop_size_dec1_raw_ls0_a1_q_4_0
    if (issue_v_poss_ls0_i2 == 1'b1)
      uop_size_dec1_raw_ls0_a1_q[4:0] <= `RV_BC_DFF_DELAY uop_size_dec1_raw_ls0_i2[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      uop_size_dec1_raw_ls0_a1_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_srca_v_ls0_a1_q
    if (issue_v_poss_ls0_i2 == 1'b1)
      srca_v_ls0_a1_q <= `RV_BC_DFF_DELAY srca_v_ls0_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      srca_v_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_issue_cancel_ls0_i2_dly_q
    if (reset_i == 1'b1)
      issue_cancel_ls0_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls0_i2 == 1'b1)
      issue_cancel_ls0_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls0_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls0_i2 == 1'b0)
    begin
    end
    else
      issue_cancel_ls0_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls0_i2 == 1'b1)
      issue_cancel_ls0_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls0_i2;
`endif
  end



  always_ff @(posedge clk_agu0)
  begin: u_agu_addend_a_ls0_a1_q_31_0
    if (agu_addend_a_en_ls0_i2[0] == 1'b1)
      agu_addend_a_ls0_a1_q[31:0] <= `RV_BC_DFF_DELAY agu_addend_a_ls0_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls0_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls0_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_agu_addend_a_ls0_a1_q_63_32
    if (agu_addend_a_en_ls0_i2[1] == 1'b1)
      agu_addend_a_ls0_a1_q[63:32] <= `RV_BC_DFF_DELAY agu_addend_a_ls0_i2[63:32];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls0_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls0_a1_q[63:32] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_srca_hi_eq_zero_ls0_a1_q
    if (reset_i == 1'b1)
      srca_hi_eq_zero_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_a_en_ls0_i2[0] == 1'b1)
      srca_hi_eq_zero_ls0_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls0_i2;
    else if (reset_i == 1'b0 && agu_addend_a_en_ls0_i2[0] == 1'b0)
    begin
    end
    else
      srca_hi_eq_zero_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_a_en_ls0_i2[0] == 1'b1)
      srca_hi_eq_zero_ls0_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls0_i2;
`endif
  end



  always_ff @(posedge clk_agu0)
  begin: u_agu_addend_b_ls0_a1_q_34_0
    if (agu_addend_b_en_ls0_i2[0] == 1'b1)
      agu_addend_b_ls0_a1_q[34:0] <= `RV_BC_DFF_DELAY agu_addend_b_ls0_i2[34:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls0_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls0_a1_q[34:0] <= `RV_BC_DFF_DELAY {35{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0)
  begin: u_agu_addend_b_ls0_a1_q_63_35
    if (agu_addend_b_en_ls0_i2[1] == 1'b1)
      agu_addend_b_ls0_a1_q[63:35] <= `RV_BC_DFF_DELAY agu_addend_b_ls0_i2[63:35];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls0_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls0_a1_q[63:35] <= `RV_BC_DFF_DELAY {29{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_srcb_eq_zero_ls0_a1_q_1
    if (reset_i == 1'b1)
      srcb_eq_zero_ls0_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_b_en_ls0_i2[1] == 1'b1)
      srcb_eq_zero_ls0_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls0_i2[1];
    else if (reset_i == 1'b0 && agu_addend_b_en_ls0_i2[1] == 1'b0)
    begin
    end
    else
      srcb_eq_zero_ls0_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_b_en_ls0_i2[1] == 1'b1)
      srcb_eq_zero_ls0_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls0_i2[1];
`endif
  end

  rv_bc_dffr #(.W(1))  u_srcb_eq_zero_ls0_0 (.q(srcb_eq_zero_ls0_a1_q[0]),         .din(srcb_eq_zero_ls0_i2[0]),         .clk(clk_agu0), .en(agu_addend_b_en_ls0_i2[0]), .reset(reset_i));
  rv_bc_dff  #(.W(1))  u_carry_in_ls0_0  (.q(carry_in_ls0_a1_q),                .din(carry_in_ls0_i2),                .clk(clk_agu0), .en(agu_addend_b_en_ls0_i2[0]));
  assign ls0_cin_0_a1 = carry_in_ls0_a1_q;

 assign srcb_eq_zero_ls0_a1[1:0] = srcb_eq_zero_ls0_a1_q[1:0];

  assign srcp_data_ls0_i2_en = issue_v_poss_ls0_i2 & is_ls_srcp_v_ls0_i2;

  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_srcp_data_ls0_a1_q_3_0
    if (reset_i == 1'b1)
      srcp_data_ls0_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcp_data_ls0_i2_en == 1'b1)
      srcp_data_ls0_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls0_i2[3:0];
    else if (reset_i == 1'b0 && srcp_data_ls0_i2_en == 1'b0)
    begin
    end
    else
      srcp_data_ls0_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (srcp_data_ls0_i2_en == 1'b1)
      srcp_data_ls0_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls0_i2[3:0];
`endif
  end


  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_a_ls0_1 (.q(agu_addend_a_dup_ls0_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_a_ls0_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu0), .en(agu_addend_a_dup_en_ls0_i2));
  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_b_ls0_1 (.q(agu_addend_b_dup_ls0_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_b_ls0_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu0), .en(agu_addend_b_dup_en_ls0_i2));
  rv_bc_dff  #(.W(1))                       u_carry_in_ls0_1  (.q(carry_in_dup_ls0_a1_q),                                  .din(carry_in_ls0_i2),                                      .clk(clk_agu0), .en(agu_addend_b_dup_en_ls0_i2));
  rv_bc_dffr #(.W(1))                       u_srcb_eq_zero_ls0_1 (.q(srcb_eq_zero_dup_ls0_a1_q),                              .din(srcb_eq_zero_ls0_i2[0]),                               .clk(clk_agu0), .en(agu_addend_b_dup_en_ls0_i2), .reset(reset_i));

  assign va_dup_ls0_a1[`RV_BC_LS_VA_ALIAS_MSB:0] = agu_addend_a_dup_ls0_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + agu_addend_b_dup_ls0_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + { {`RV_BC_LS_VA_ALIAS_MSB{1'b0}}, carry_in_dup_ls0_a1_q};

  assign va_dup_ls0_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1] = va_ls0_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1];


  assign {ls0_fast_cout11_a1, ls0_fast_va_a1[11:0]} = agu_addend_a_ls0_a1_q[11:0] + agu_addend_b_ls0_a1_q[11:0] + {{11{1'b0}}, ls0_cin_0_a1};


  assign {end_byte_carry_out_5_ls0_a1, end_byte_ls0_a1[5:0]}   = {1'b0, ls0_fast_va_a1[5:0]}     
                                                                   + {2'b0, uop_size_dec1_raw_ls0_a1_q[4:0]};

  assign end_byte_carry_out_2_ls0_a1 = uop_size_dec1_raw_ls0_a1_q[2] & (|ls0_fast_va_a1[2:0])
                                       | uop_size_dec1_raw_ls0_a1_q[1] &   ls0_fast_va_a1[2] & (|ls0_fast_va_a1[1:0])
                                       | uop_size_dec1_raw_ls0_a1_q[0] & (&ls0_fast_va_a1[2:0]);





  always_comb 
  begin: u_ls0_srca_hash_a1_raw
   ls0_srca_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls0_srca_hash_a1_raw[macro_i] = ls0_srca_hash_a1_raw[macro_i] ^ agu_addend_a_ls0_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls0_srcb_hash_a1_raw
   ls0_srcb_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls0_srcb_hash_a1_raw[macro_i] = ls0_srcb_hash_a1_raw[macro_i] ^ agu_addend_b_ls0_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls0_cin_hash_a1_raw
   ls0_cin_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls0_cin_hash_a1_raw[macro_i] = ls0_cin_hash_a1_raw[macro_i] ^ ls0_cin_a1[macro_j];
  end





  assign ls0_srca_hash_final_a1[4:0] =  ls0_srca_hash_a1_raw[4:0]
                                                       ^ ls0_srcb_hash_a1_raw[4:0]           
                                                       ^ ls0_cin_hash_a1_raw[ 4:0];          


  always_ff @(posedge clk)
  begin: u_ls0_srca_hash_a2_q_4_0
    if (ld_val_ls0_a1 == 1'b1)
      ls0_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY ls0_srca_hash_final_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ls0_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  assign ls0_srca_hash_a1[4:0] = (ls0_srca_hash_a1_raw[4:0] ^ ls0_srcb_hash_a1_raw[4:0]);

  assign cache_line_split_ls0_a1  = end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q; 

  assign ls0_cache_split1_val_a1 = ld_val_ls0_a1 & cache_line_split_ls0_a1 & ~prevent_unalign_ls0_a1 & ~ls0_non_sized_a1;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls0_cache_split2_a1_q
    if (reset_i == 1'b1)
      ls0_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls0_cache_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ls0_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ls0_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls0_cache_split1_val_a1;
`endif
  end


  assign {uop_32b_low_end_byte_carry_out_5_ls0_a1, uop_32b_low_end_byte_ls0_a1[5:3]}   = {1'b0, ls0_fast_va_a1[5:3]}     
                                                                                     + {3'b0, uop_size_dec1_raw_ls0_a1_q[3]}
                                                                                     + {3'b0, end_byte_carry_out_2_ls0_a1};


  assign  end_byte_adjust_ls0_a1[3:0]   = unalign2_ls0_i2 ? 4'b1111 : end_byte_ls0_a1[3:0]; 
  assign  end_byte_adjust_ls0_a1[5:4]   = (unalign2_ls0_i2  | unalign2_ls0_a1_q) ? ls0_fast_va_a1[5:4] : end_byte_ls0_a1[5:4];


  assign  va_adjust_ls0_a1[3:0] = {4{~unalign2_ls0_a1_q}} & ls0_fast_va_a1[3:0];

  assign ls0_uop_cross_16_byte_a1 = (end_byte_ls0_a1[4] != ls0_fast_va_a1[4]);
  assign ls0_uop_cross_32_byte_a1 = (end_byte_ls0_a1[5] != ls0_fast_va_a1[5]);

  assign ls0_ld_cross_16_32_byte_a1 = ls0_uop_cross_16_byte_a1 | ls0_uop_cross_32_byte_a1;


  always_ff @(posedge clk)
  begin: u_ls0_ld_cross_16_32_byte_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      ls0_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY ls0_ld_cross_16_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ls0_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls0_ld_cross_32_byte_a2_q
    if (ld_val_ls0_a1 == 1'b1)
      ls0_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY ls0_uop_cross_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_a1 == 1'b0)
    begin
    end
    else
      ls0_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ls0_uop_size_16byte_a1 =  ~uop_size_dec1_raw_ls0_a1_q[4] & (&uop_size_dec1_raw_ls0_a1_q[3:0]);
  assign ls0_uop_size_32byte_a1 = (&uop_size_dec1_raw_ls0_a1_q[4:0]);

  assign unalign_qw_split_ls0_a1  = &uop_size_dec1_raw_ls0_a1_q[3:0] & (|va_adjust_ls0_a1[1:0]);
  assign unalign_hw_split_ls0_a1  = 1'b0;
  assign ls0_non_sized_a1 = address_inject_val_ls0_a1_q
                            | ( (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                              & (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_CC_ATOMIC] == 4'b0011))           
                            | ls_ctl_format_ls0_a1;

  assign st_cache_line_split_ls0_a1  = end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q & ~ls0_non_sized_a1;

 
  assign st_low_cache_line_split_ls0_a1 = uop_32b_low_end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q            & ~ls0_non_sized_a1;
  assign st_mid_cache_line_split_ls0_a1 = ({uop_32b_low_end_byte_ls0_a1[5:3], end_byte_ls0_a1[2:0]} == 6'h3f)  & ~unalign2_ls0_a1_q & ~ls0_non_sized_a1 
                                          & ~(ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                                          ;
  assign st_hi_cache_line_split_ls0_a1  = end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q & ~ls0_non_sized_a1 
                                          & ( (~uop_32b_low_end_byte_carry_out_5_ls0_a1 & ~({uop_32b_low_end_byte_ls0_a1[5:3], end_byte_ls0_a1[2:0]} == 6'h3f))
                                            | (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)     
                                          );

  assign st_low_end_byte_ls0_a1[5:3] = uop_32b_low_end_byte_ls0_a1[5:3];

  assign page_split_ls0_a1   = end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q & (&ls0_fast_va_a1[11:6]) & ~ls0_non_sized_a1;

  assign ls0_page_split1_a1  = end_byte_carry_out_5_ls0_a1 & ~unalign2_ls0_a1_q & (&ls0_fast_va_a1[11:6]) & ~ls0_non_sized_a1;   

  assign ls0_ld_page_split1_a1 = ld_val_ls0_a1 & ls0_page_split1_a1;
  assign ls0_st_page_split1_a1 = issue_st_val_ls0_a1_q & ls0_page_split1_a1;
  assign ls0_page_split1_early_val_a1 = (ld_val_ls0_a1 | st_val_ls0_a1)  & ls0_page_split1_a1;
  assign ls0_page_split1_val_a1 = ls0_page_split1_early_val_a1 & ~prevent_unalign_ls0_a1;




  assign unalign2_ls0_i2       = unalign1_ls0_a1 & ~prevent_unalign_ls0_a1;
  assign reject_unalign_ls0_a1 = unalign1_ls0_a1 &  prevent_unalign_ls0_a1;


  
  assign ls_ctl_format_ls1_i2 = ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] 
                                  & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls1_i2_q[4:3])
                                  & ~(ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                         
                                  & ((~(&ls_uop_ctl_ls1_i2_q[3:2]) | ~(|ls_uop_ctl_ls1_i2_q[1:0])) | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  assign ls_ctl_format_ls1_a1 = st_val_ls1_a1 & ~ls_uop_ctl_ls1_a1_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls1_a1_q[4:3]) 
                                  & ~(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                          
                                  & ((~(&ls_uop_ctl_ls1_a1_q[3:2]) | ~(|ls_uop_ctl_ls1_a1_q[1:0])) | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  always_comb 
  begin: u_uop_size_dec1_raw_ls1_i2_4_0
    casez({ls_ctl_format_ls1_i2, ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_T_SIZE]})
      {1'b1, 3'b???}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_B}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_H}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b00001;  
      {1'b0, `RV_BC_SIZE_W}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b00011;  
      {1'b0, `RV_BC_SIZE_D}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b00111;  
      {1'b0, `RV_BC_SIZE_16}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b01111;  
      {1'b0, `RV_BC_SIZE_32}: uop_size_dec1_raw_ls1_i2[4:0] = 5'b11111;  
      default: uop_size_dec1_raw_ls1_i2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls_ctl_format_ls1_i2, ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_T_SIZE]})) === 1'bx)
      uop_size_dec1_raw_ls1_i2[4:0] = {5{1'bx}};
`endif
  end


  assign ls1_pf_trainable_type_a1 = ( st_val_ls1_a1 & ( (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_ST)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STTR)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STNP)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STLR)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST2)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST3)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST4)
                                                          )
                                      | ld_val_ls1_a1 & ( (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDAR)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDTR)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDNP)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                                          | ((ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_LD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3)
                                                          | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4)
                                                          ));


  assign issue_ld_val_ls1_i2            = issue_v_ls1_i2   & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q;

  assign issue_ld_val_possible_ls1_i2   = issue_v_ls1_i2_q & ~is_ls_issue_cancel_ls1_i2   & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q;

  assign issue_pld_val_possible_ls1_i2  =    issue_ld_val_possible_ls1_i2
                                            & (
                                                  (ls_uop_ctl_ls1_i2_q[5:4] == 2'b01) 
                                                | (ls_uop_ctl_ls1_i2_q[5:3] == 3'b100)
                                              );

  assign issue_ld_val_early_ls1_i2      = issue_v_early_ls1_i2   & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q;


  assign issue_st_val_ls1_i2            = issue_v_ls1_i2_q &  ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q & ~unalign2_ls1_i2;
  assign issue_st_val_ls1_a1_din        = issue_v_ls1_i2   &  ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q;

  assign issue_ld_val_ls1_a1            = issue_ld_val_ls1_a1_q & ~ls_is_uop_reject_ls1_d1;
  assign issue_st_val_ls1_a1            = issue_st_val_ls1_a1_q;

  assign ld_val_ls1_a1          = unalign2_dup_ls1_a1_q ? ld_val_ls1_a2_q 
                                                            : issue_ld_val_ls1_a1;

  assign st_val_ls1_a1          = unalign2_ls1_a1_q ? st_val_ls1_a2_q
                                                        : issue_st_val_ls1_a1;

  assign tlb_cam_v_ld_st_ccpass_ls1_a1          =   pf_tlb_inject_v_ls1_a1                                           
                                                    | spe_inject_val_ls1_a1_q                                          
                                                    | tbe_inject_val_ls1_a1_q                                          
                                                    | (  (   ld_val_ls1_a1                                             
                                                           | (st_val_ls1_a1 & ~st_no_xlat_ls1_a1)                    
                                                         )
                                                       & ccpass_ls1_a1                                                 
                                                       & (~unalign2_ls1_a1_q | ls1_page_split2_a1_q)                   
                                                      ) ;

  assign va_v_ld_st_ccpass_ls1_a1               =   pf_tlb_inject_v_ls1_a1                                           
                                                    | spe_inject_val_ls1_a1_q                                          
                                                    | tbe_inject_val_ls1_a1_q                                          
                                                    | (  (   ld_val_ls1_a1                                             
                                                           | (st_val_ls1_a1 & ~st_no_xlat_ls1_a1)                    
                                                         )
                                                       & ccpass_ls1_a1                                                 

                                                      ) ;
     
  assign tlb_cam_v_ls1_a1                       = tlb_cam_v_ld_st_ccpass_ls1_a1 | address_inject_val_ls1_a1_q ;                                     
  assign va_v_ls1_a1                            = va_v_ld_st_ccpass_ls1_a1      | address_inject_val_ls1_a1_q ;                                     

  assign agu_addend_a_ls1_i2[31:0]  = {32{ unalign2_ls1_i2                           }} & va_ls1_a1[31:0]
                                      | {32{~unalign2_ls1_i2 & is_ls_srca_v_ls1_i2[0]}} & is_ls_srca_data_ls1_i2[31:0];

  assign agu_addend_a_ls1_i2[63:32] = {32{ unalign2_ls1_i2                                                                                                 }} & va_ls1_a1[63:32]
                                      | {32{~unalign2_ls1_i2 & is_ls_srca_v_ls1_i2[1] & (~cpsr_aarch32 | tmo_inject_val_ls1_i2 | spe_inject_val_ls1_i2 | tbe_inject_val_ls1_i2)}} & is_ls_srca_data_ls1_i2[63:32];


  assign srcb_sel_no_shift_ls1_i2   =   is_ls_srcb_v_ls1_i2[0] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_NO_SH)    & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;
  assign srcb_sel_shift1_ls1_i2     =   is_ls_srcb_v_ls1_i2[0] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH1)      & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;  
  assign srcb_sel_shift2_ls1_i2     =   is_ls_srcb_v_ls1_i2[0] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH2)      & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;
  assign srcb_sel_shift3_ls1_i2     =   is_ls_srcb_v_ls1_i2[0] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH3)      & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;

  assign srcb_sel_no_ext_ls1_i2     =                            ( (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_NO_EXT)
                                                                   | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)) & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;

  assign srcb_sel_sext_ls1_i2       =   is_ls_srcb_v_ls1_i2[0] & (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_SEXT)     & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;

  assign carry_in_ls1_i2            =                              (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)  & ~unalign2_ls1_i2 & ~address_inject_val_ls1_i2_q;



  assign ls1_32byte_ld_st_cache_line_split_2nd_half_a1 = (ls1_fast_va_a1[5:4] != 2'b11 ) & uop_size_dec1_raw_ls1_a1_q[4] ; 
  assign unalign2_src_b_ls1_i2[31:0] = issue_st_val_ls1_a1_q & ls1_32byte_ld_st_cache_line_split_2nd_half_a1 ?  32'h20 : 32'h10 ; 

  assign agu_addend_b_ls1_i2[31:0]  = {32{unalign2_ls1_i2}}          & unalign2_src_b_ls1_i2[31:0] 
                                      | {32{srcb_sel_no_shift_ls1_i2}} &  is_ls_srcb_data_ls1_i2[31:0]
                                      | {32{srcb_sel_shift1_ls1_i2}}   & {is_ls_srcb_data_ls1_i2[30:0], 1'b0}
                                      | {32{srcb_sel_shift2_ls1_i2}}   & {is_ls_srcb_data_ls1_i2[29:0], 2'b0}
                                      | {32{srcb_sel_shift3_ls1_i2}}   & {is_ls_srcb_data_ls1_i2[28:0], 3'b0};

  assign agu_addend_b_ls1_i2[32]    =     srcb_sel_no_shift_ls1_i2   &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[32]
                                      |     srcb_sel_no_shift_ls1_i2   &  srcb_sel_sext_ls1_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift1_ls1_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift2_ls1_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[30]
                                      |     srcb_sel_shift3_ls1_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[29];

  assign agu_addend_b_ls1_i2[33]    =     srcb_sel_no_shift_ls1_i2   &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[33]
                                      |     srcb_sel_no_shift_ls1_i2   &  srcb_sel_sext_ls1_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift1_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[32]
                                      |     srcb_sel_shift1_ls1_i2     &  srcb_sel_sext_ls1_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift2_ls1_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift3_ls1_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[30];

  assign agu_addend_b_ls1_i2[34]    =     srcb_sel_no_shift_ls1_i2   &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[34]
                                      |    (srcb_sel_shift3_ls1_i2     |  srcb_sel_sext_ls1_i2)  & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[31]
                                      |     srcb_sel_shift2_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[32]
                                      |     srcb_sel_shift1_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]   & is_ls_srcb_data_ls1_i2[33];

  assign agu_addend_b_ls1_i2[63:35] = {29{srcb_sel_no_shift_ls1_i2   &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]}} & is_ls_srcb_data_ls1_i2[63:35]
                                      | {29{srcb_sel_shift1_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]}} & is_ls_srcb_data_ls1_i2[62:34]
                                      | {29{srcb_sel_shift2_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]}} & is_ls_srcb_data_ls1_i2[61:33]
                                      | {29{srcb_sel_shift3_ls1_i2     &  srcb_sel_no_ext_ls1_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls1_i2[1]}} & is_ls_srcb_data_ls1_i2[60:32]
                                      |                                 {29{srcb_sel_sext_ls1_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls1_i2[   31]}};

  assign srcb_eq_zero_ls1_i2[0] = ~unalign2_ls1_i2 & ~is_ls_srcb_v_ls1_i2[0] & ~carry_in_ls1_i2 
                                  | address_inject_val_ls1_i2_q;

  assign srcb_eq_zero_ls1_i2[1] = ~( is_ls_srcb_v_ls1_i2[1]
                                     | is_ls_srcb_v_ls1_i2[0] & srcb_sel_sext_ls1_i2 & is_ls_srcb_data_ls1_i2[31])    
                                  |  unalign2_ls1_i2 
                                  |  address_inject_val_ls1_i2_q
                                  |  cpsr_aarch32;

  assign srca_hi_eq_zero_ls1_i2 = ~(is_ls_srca_v_ls1_i2[1] | unalign2_ls1_i2) 
                                  |  (cpsr_aarch32 & ~address_inject_val_ls1_i2_q);

  assign srca_v_ls1_i2          = is_ls_srca_v_ls1_i2[0] | unalign2_ls1_i2;

  assign agu_addend_a_en_ls1_i2[0] = (   issue_v_ls1_i2_q
                                        &  (  is_ls_srca_v_ls1_i2[0]
                                             | invdbg_ok                                      
                                           )
                                       )
                                     |  unalign2_ls1_i2;


  assign agu_addend_a_en_ls1_i2[1] = ( issue_v_ls1_i2_q
                                       &  (  is_ls_srca_v_ls1_i2[1]
                                          | ~srca_hi_eq_zero_ls1_a1_q))                       
                                     |  unalign2_ls1_i2;

  assign agu_addend_b_en_ls1_i2[0] = ( issue_v_ls1_i2_q
                                       &  (  is_ls_srcb_v_ls1_i2[0]
                                          |  carry_in_ls1_i2
                                          | ~srcb_eq_zero_ls1_a1_q[0]                        
                                          | invdbg_ok                                           
                                          )
                                        )
                                     |  unalign2_ls1_i2;

  assign agu_addend_b_en_ls1_i2[1] = ( issue_v_ls1_i2_q
                                       &  (  is_ls_srcb_v_ls1_i2[1]
                                          |  is_ls_srcb_v_ls1_i2[0] & srcb_sel_sext_ls1_i2 
                                          |  issue_cancel_ls1_i2_dly_q                       
                                          | ~srcb_eq_zero_ls1_a1_q[1]))                      
                                     |  unalign2_ls1_i2;


  assign st_pf_vld_ls1_i2 = ~address_inject_val_ls1_i2_q & ~(
                             | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_TYPE_ATOMIC] )
                             | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STREX )
                             | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] ==  `RV_BC_LS_TYPE_STLXR )
                             | ls_ctl_format_ls1_i2); 



  assign agu_addend_a_dup_en_ls1_i2 = ( issue_v_ls1_i2_q & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q & ~unalign2_ls1_i2
                                        &  (  is_ls_srca_v_ls1_i2[0]))                       
                                      | (unalign2_ls1_i2 & issue_ld_val_ls1_a1)
                                      | ((issue_v_ls1_i2_q | unalign2_ls1_i2) & (invdbg_ok |                         
                                                                                     rst_full_ls1_q & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls1_i2));     
  assign agu_addend_b_dup_en_ls1_i2 = ( issue_v_ls1_i2_q & ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls1_i2_q & ~unalign2_ls1_i2
                                        &  (  is_ls_srcb_v_ls1_i2[0]
                                           |  carry_in_ls1_i2
                                           | ~srcb_eq_zero_dup_ls1_a1_q))                        
                                      | (unalign2_ls1_i2 & issue_ld_val_ls1_a1)
                                      | ((issue_v_ls1_i2_q | unalign2_ls1_i2) & (invdbg_ok | 
                                                                                      rst_full_ls1_q & ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls1_i2));     


  always_ff @(posedge clk_agu1)
  begin: u_uop_size_dec1_raw_ls1_a1_q_4_0
    if (issue_v_poss_ls1_i2 == 1'b1)
      uop_size_dec1_raw_ls1_a1_q[4:0] <= `RV_BC_DFF_DELAY uop_size_dec1_raw_ls1_i2[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      uop_size_dec1_raw_ls1_a1_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_srca_v_ls1_a1_q
    if (issue_v_poss_ls1_i2 == 1'b1)
      srca_v_ls1_a1_q <= `RV_BC_DFF_DELAY srca_v_ls1_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      srca_v_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_issue_cancel_ls1_i2_dly_q
    if (reset_i == 1'b1)
      issue_cancel_ls1_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls1_i2 == 1'b1)
      issue_cancel_ls1_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls1_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls1_i2 == 1'b0)
    begin
    end
    else
      issue_cancel_ls1_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls1_i2 == 1'b1)
      issue_cancel_ls1_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls1_i2;
`endif
  end



  always_ff @(posedge clk_agu1)
  begin: u_agu_addend_a_ls1_a1_q_31_0
    if (agu_addend_a_en_ls1_i2[0] == 1'b1)
      agu_addend_a_ls1_a1_q[31:0] <= `RV_BC_DFF_DELAY agu_addend_a_ls1_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls1_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls1_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_agu_addend_a_ls1_a1_q_63_32
    if (agu_addend_a_en_ls1_i2[1] == 1'b1)
      agu_addend_a_ls1_a1_q[63:32] <= `RV_BC_DFF_DELAY agu_addend_a_ls1_i2[63:32];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls1_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls1_a1_q[63:32] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_srca_hi_eq_zero_ls1_a1_q
    if (reset_i == 1'b1)
      srca_hi_eq_zero_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_a_en_ls1_i2[0] == 1'b1)
      srca_hi_eq_zero_ls1_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls1_i2;
    else if (reset_i == 1'b0 && agu_addend_a_en_ls1_i2[0] == 1'b0)
    begin
    end
    else
      srca_hi_eq_zero_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_a_en_ls1_i2[0] == 1'b1)
      srca_hi_eq_zero_ls1_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls1_i2;
`endif
  end



  always_ff @(posedge clk_agu1)
  begin: u_agu_addend_b_ls1_a1_q_34_0
    if (agu_addend_b_en_ls1_i2[0] == 1'b1)
      agu_addend_b_ls1_a1_q[34:0] <= `RV_BC_DFF_DELAY agu_addend_b_ls1_i2[34:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls1_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls1_a1_q[34:0] <= `RV_BC_DFF_DELAY {35{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1)
  begin: u_agu_addend_b_ls1_a1_q_63_35
    if (agu_addend_b_en_ls1_i2[1] == 1'b1)
      agu_addend_b_ls1_a1_q[63:35] <= `RV_BC_DFF_DELAY agu_addend_b_ls1_i2[63:35];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls1_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls1_a1_q[63:35] <= `RV_BC_DFF_DELAY {29{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_srcb_eq_zero_ls1_a1_q_1
    if (reset_i == 1'b1)
      srcb_eq_zero_ls1_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_b_en_ls1_i2[1] == 1'b1)
      srcb_eq_zero_ls1_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls1_i2[1];
    else if (reset_i == 1'b0 && agu_addend_b_en_ls1_i2[1] == 1'b0)
    begin
    end
    else
      srcb_eq_zero_ls1_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_b_en_ls1_i2[1] == 1'b1)
      srcb_eq_zero_ls1_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls1_i2[1];
`endif
  end

  rv_bc_dffr #(.W(1))  u_srcb_eq_zero_ls1_0 (.q(srcb_eq_zero_ls1_a1_q[0]),         .din(srcb_eq_zero_ls1_i2[0]),         .clk(clk_agu1), .en(agu_addend_b_en_ls1_i2[0]), .reset(reset_i));
  rv_bc_dff  #(.W(1))  u_carry_in_ls1_0  (.q(carry_in_ls1_a1_q),                .din(carry_in_ls1_i2),                .clk(clk_agu1), .en(agu_addend_b_en_ls1_i2[0]));
  assign ls1_cin_0_a1 = carry_in_ls1_a1_q;

 assign srcb_eq_zero_ls1_a1[1:0] = srcb_eq_zero_ls1_a1_q[1:0];

  assign srcp_data_ls1_i2_en = issue_v_poss_ls1_i2 & is_ls_srcp_v_ls1_i2;

  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_srcp_data_ls1_a1_q_3_0
    if (reset_i == 1'b1)
      srcp_data_ls1_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcp_data_ls1_i2_en == 1'b1)
      srcp_data_ls1_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls1_i2[3:0];
    else if (reset_i == 1'b0 && srcp_data_ls1_i2_en == 1'b0)
    begin
    end
    else
      srcp_data_ls1_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (srcp_data_ls1_i2_en == 1'b1)
      srcp_data_ls1_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls1_i2[3:0];
`endif
  end


  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_a_ls1_1 (.q(agu_addend_a_dup_ls1_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_a_ls1_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu1), .en(agu_addend_a_dup_en_ls1_i2));
  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_b_ls1_1 (.q(agu_addend_b_dup_ls1_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_b_ls1_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu1), .en(agu_addend_b_dup_en_ls1_i2));
  rv_bc_dff  #(.W(1))                       u_carry_in_ls1_1  (.q(carry_in_dup_ls1_a1_q),                                  .din(carry_in_ls1_i2),                                      .clk(clk_agu1), .en(agu_addend_b_dup_en_ls1_i2));
  rv_bc_dffr #(.W(1))                       u_srcb_eq_zero_ls1_1 (.q(srcb_eq_zero_dup_ls1_a1_q),                              .din(srcb_eq_zero_ls1_i2[0]),                               .clk(clk_agu1), .en(agu_addend_b_dup_en_ls1_i2), .reset(reset_i));

  assign va_dup_ls1_a1[`RV_BC_LS_VA_ALIAS_MSB:0] = agu_addend_a_dup_ls1_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + agu_addend_b_dup_ls1_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + { {`RV_BC_LS_VA_ALIAS_MSB{1'b0}}, carry_in_dup_ls1_a1_q};

  assign va_dup_ls1_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1] = va_ls1_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1];


  assign {ls1_fast_cout11_a1, ls1_fast_va_a1[11:0]} = agu_addend_a_ls1_a1_q[11:0] + agu_addend_b_ls1_a1_q[11:0] + {{11{1'b0}}, ls1_cin_0_a1};


  assign {end_byte_carry_out_5_ls1_a1, end_byte_ls1_a1[5:0]}   = {1'b0, ls1_fast_va_a1[5:0]}     
                                                                   + {2'b0, uop_size_dec1_raw_ls1_a1_q[4:0]};

  assign end_byte_carry_out_2_ls1_a1 = uop_size_dec1_raw_ls1_a1_q[2] & (|ls1_fast_va_a1[2:0])
                                       | uop_size_dec1_raw_ls1_a1_q[1] &   ls1_fast_va_a1[2] & (|ls1_fast_va_a1[1:0])
                                       | uop_size_dec1_raw_ls1_a1_q[0] & (&ls1_fast_va_a1[2:0]);





  always_comb 
  begin: u_ls1_srca_hash_a1_raw
   ls1_srca_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls1_srca_hash_a1_raw[macro_i] = ls1_srca_hash_a1_raw[macro_i] ^ agu_addend_a_ls1_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls1_srcb_hash_a1_raw
   ls1_srcb_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls1_srcb_hash_a1_raw[macro_i] = ls1_srcb_hash_a1_raw[macro_i] ^ agu_addend_b_ls1_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls1_cin_hash_a1_raw
   ls1_cin_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls1_cin_hash_a1_raw[macro_i] = ls1_cin_hash_a1_raw[macro_i] ^ ls1_cin_a1[macro_j];
  end





  assign ls1_srca_hash_final_a1[4:0] =  ls1_srca_hash_a1_raw[4:0]
                                                       ^ ls1_srcb_hash_a1_raw[4:0]           
                                                       ^ ls1_cin_hash_a1_raw[ 4:0];          


  always_ff @(posedge clk)
  begin: u_ls1_srca_hash_a2_q_4_0
    if (ld_val_ls1_a1 == 1'b1)
      ls1_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY ls1_srca_hash_final_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ls1_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  assign ls1_srca_hash_a1[4:0] = (ls1_srca_hash_a1_raw[4:0] ^ ls1_srcb_hash_a1_raw[4:0]);

  assign cache_line_split_ls1_a1  = end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q; 

  assign ls1_cache_split1_val_a1 = ld_val_ls1_a1 & cache_line_split_ls1_a1 & ~prevent_unalign_ls1_a1 & ~ls1_non_sized_a1;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls1_cache_split2_a1_q
    if (reset_i == 1'b1)
      ls1_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls1_cache_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ls1_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ls1_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls1_cache_split1_val_a1;
`endif
  end


  assign {uop_32b_low_end_byte_carry_out_5_ls1_a1, uop_32b_low_end_byte_ls1_a1[5:3]}   = {1'b0, ls1_fast_va_a1[5:3]}     
                                                                                     + {3'b0, uop_size_dec1_raw_ls1_a1_q[3]}
                                                                                     + {3'b0, end_byte_carry_out_2_ls1_a1};


  assign  end_byte_adjust_ls1_a1[3:0]   = unalign2_ls1_i2 ? 4'b1111 : end_byte_ls1_a1[3:0]; 
  assign  end_byte_adjust_ls1_a1[5:4]   = (unalign2_ls1_i2  | unalign2_ls1_a1_q) ? ls1_fast_va_a1[5:4] : end_byte_ls1_a1[5:4];


  assign  va_adjust_ls1_a1[3:0] = {4{~unalign2_ls1_a1_q}} & ls1_fast_va_a1[3:0];

  assign ls1_uop_cross_16_byte_a1 = (end_byte_ls1_a1[4] != ls1_fast_va_a1[4]);
  assign ls1_uop_cross_32_byte_a1 = (end_byte_ls1_a1[5] != ls1_fast_va_a1[5]);

  assign ls1_ld_cross_16_32_byte_a1 = ls1_uop_cross_16_byte_a1 | ls1_uop_cross_32_byte_a1;


  always_ff @(posedge clk)
  begin: u_ls1_ld_cross_16_32_byte_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      ls1_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY ls1_ld_cross_16_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ls1_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls1_ld_cross_32_byte_a2_q
    if (ld_val_ls1_a1 == 1'b1)
      ls1_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY ls1_uop_cross_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_a1 == 1'b0)
    begin
    end
    else
      ls1_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ls1_uop_size_16byte_a1 =  ~uop_size_dec1_raw_ls1_a1_q[4] & (&uop_size_dec1_raw_ls1_a1_q[3:0]);
  assign ls1_uop_size_32byte_a1 = (&uop_size_dec1_raw_ls1_a1_q[4:0]);

  assign unalign_qw_split_ls1_a1  = &uop_size_dec1_raw_ls1_a1_q[3:0] & (|va_adjust_ls1_a1[1:0]);
  assign unalign_hw_split_ls1_a1  = 1'b0;
  assign ls1_non_sized_a1 = address_inject_val_ls1_a1_q
                            | ( (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                              & (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_CC_ATOMIC] == 4'b0011))           
                            | ls_ctl_format_ls1_a1;

  assign st_cache_line_split_ls1_a1  = end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q & ~ls1_non_sized_a1;

 
  assign st_low_cache_line_split_ls1_a1 = uop_32b_low_end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q            & ~ls1_non_sized_a1;
  assign st_mid_cache_line_split_ls1_a1 = ({uop_32b_low_end_byte_ls1_a1[5:3], end_byte_ls1_a1[2:0]} == 6'h3f)  & ~unalign2_ls1_a1_q & ~ls1_non_sized_a1 
                                          & ~(ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                                          ;
  assign st_hi_cache_line_split_ls1_a1  = end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q & ~ls1_non_sized_a1 
                                          & ( (~uop_32b_low_end_byte_carry_out_5_ls1_a1 & ~({uop_32b_low_end_byte_ls1_a1[5:3], end_byte_ls1_a1[2:0]} == 6'h3f))
                                            | (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)     
                                          );

  assign st_low_end_byte_ls1_a1[5:3] = uop_32b_low_end_byte_ls1_a1[5:3];

  assign page_split_ls1_a1   = end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q & (&ls1_fast_va_a1[11:6]) & ~ls1_non_sized_a1;

  assign ls1_page_split1_a1  = end_byte_carry_out_5_ls1_a1 & ~unalign2_ls1_a1_q & (&ls1_fast_va_a1[11:6]) & ~ls1_non_sized_a1;   

  assign ls1_ld_page_split1_a1 = ld_val_ls1_a1 & ls1_page_split1_a1;
  assign ls1_st_page_split1_a1 = issue_st_val_ls1_a1_q & ls1_page_split1_a1;
  assign ls1_page_split1_early_val_a1 = (ld_val_ls1_a1 | st_val_ls1_a1)  & ls1_page_split1_a1;
  assign ls1_page_split1_val_a1 = ls1_page_split1_early_val_a1 & ~prevent_unalign_ls1_a1;

  assign prevent_unalign_ls1_a1 = ls1_precommit_uop_i2_unqual & (lsx_precommit_uop_reject_cnt_q[1:0] == 2'b11)
                                  | address_inject_val_ls1_i2_q;


  assign unalign1_ls1_a1 = ( issue_ld_val_ls1_a1 & (cache_line_split_ls1_a1 | unalign_qw_split_ls1_a1 |  unalign_hw_split_ls1_a1)
                             | issue_st_val_ls1_a1 & page_split_ls1_a1) & ~unalign2_ls1_a1_q ;

  assign unalign2_ls1_i2       = unalign1_ls1_a1 & ~prevent_unalign_ls1_a1;
  assign reject_unalign_ls1_a1 = unalign1_ls1_a1 &  prevent_unalign_ls1_a1;


  
  assign ls_ctl_format_ls2_i2 = ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] 
                                  & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls2_i2_q[4:3])
                                  & ~(ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                         
                                  & ((~(&ls_uop_ctl_ls2_i2_q[3:2]) | ~(|ls_uop_ctl_ls2_i2_q[1:0])) | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  assign ls_ctl_format_ls2_a1 = st_val_ls2_a1 & ~ls_uop_ctl_ls2_a1_q[`RV_BC_LS_TYPE_ATOMIC] & (|ls_uop_ctl_ls2_a1_q[4:3]) 
                                  & ~(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)                                          
                                  & ((~(&ls_uop_ctl_ls2_a1_q[3:2]) | ~(|ls_uop_ctl_ls2_a1_q[1:0])) | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_DCG));   



  always_comb 
  begin: u_uop_size_dec1_raw_ls2_i2_4_0
    casez({ls_ctl_format_ls2_i2, ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_T_SIZE]})
      {1'b1, 3'b???}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_B}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b00000;  
      {1'b0, `RV_BC_SIZE_H}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b00001;  
      {1'b0, `RV_BC_SIZE_W}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b00011;  
      {1'b0, `RV_BC_SIZE_D}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b00111;  
      {1'b0, `RV_BC_SIZE_16}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b01111;  
      {1'b0, `RV_BC_SIZE_32}: uop_size_dec1_raw_ls2_i2[4:0] = 5'b11111;  
      default: uop_size_dec1_raw_ls2_i2[4:0] = {5{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({ls_ctl_format_ls2_i2, ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_T_SIZE]})) === 1'bx)
      uop_size_dec1_raw_ls2_i2[4:0] = {5{1'bx}};
`endif
  end


  assign ls2_pf_trainable_type_a1 = ( st_val_ls2_a1 & ( (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_ST)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STTR)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STNP)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STLR)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST2)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST3)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_ST4)
                                                          )
                                      | ld_val_ls2_a1 & ( (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDAR)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDTR)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDNP)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                                          | ((ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] & `RV_BC_LS_TYPE_PLD_MASK) == `RV_BC_LS_TYPE_PLD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_GATHER_LD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_FF_LD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_NF_LD)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1R)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD1RQ)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD2)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD3)
                                                          | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_LD4)
                                                          ));


  assign issue_ld_val_ls2_i2            = issue_v_ls2_i2   & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q;

  assign issue_ld_val_possible_ls2_i2   = issue_v_ls2_i2_q & ~is_ls_issue_cancel_ls2_i2   & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q;

  assign issue_pld_val_possible_ls2_i2  =    issue_ld_val_possible_ls2_i2
                                            & (
                                                  (ls_uop_ctl_ls2_i2_q[5:4] == 2'b01) 
                                                | (ls_uop_ctl_ls2_i2_q[5:3] == 3'b100)
                                              );

  assign issue_ld_val_early_ls2_i2      = issue_v_early_ls2_i2   & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q;


  assign issue_st_val_ls2_i2            = issue_v_ls2_i2_q &  ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q & ~unalign2_ls2_i2;
  assign issue_st_val_ls2_a1_din        = issue_v_ls2_i2   &  ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q;

  assign issue_ld_val_ls2_a1            = issue_ld_val_ls2_a1_q & ~ls_is_uop_reject_ls2_d1;
  assign issue_st_val_ls2_a1            = issue_st_val_ls2_a1_q;

  assign ld_val_ls2_a1          = unalign2_dup_ls2_a1_q ? ld_val_ls2_a2_q 
                                                            : issue_ld_val_ls2_a1;

  assign st_val_ls2_a1          = unalign2_ls2_a1_q ? st_val_ls2_a2_q
                                                        : issue_st_val_ls2_a1;

  assign tlb_cam_v_ld_st_ccpass_ls2_a1          =   pf_tlb_inject_v_ls2_a1                                           
                                                    | spe_inject_val_ls2_a1_q                                          
                                                    | tbe_inject_val_ls2_a1_q                                          
                                                    | (  (   ld_val_ls2_a1                                             
                                                           | (st_val_ls2_a1 & ~st_no_xlat_ls2_a1)                    
                                                         )
                                                       & ccpass_ls2_a1                                                 
                                                       & (~unalign2_ls2_a1_q | ls2_page_split2_a1_q)                   
                                                      ) ;

  assign va_v_ld_st_ccpass_ls2_a1               =   pf_tlb_inject_v_ls2_a1                                           
                                                    | spe_inject_val_ls2_a1_q                                          
                                                    | tbe_inject_val_ls2_a1_q                                          
                                                    | (  (   ld_val_ls2_a1                                             
                                                           | (st_val_ls2_a1 & ~st_no_xlat_ls2_a1)                    
                                                         )
                                                       & ccpass_ls2_a1                                                 

                                                      ) ;
     
  assign tlb_cam_v_ls2_a1                       = tlb_cam_v_ld_st_ccpass_ls2_a1 | address_inject_val_ls2_a1_q ;                                     
  assign va_v_ls2_a1                            = va_v_ld_st_ccpass_ls2_a1      | address_inject_val_ls2_a1_q ;                                     

  assign agu_addend_a_ls2_i2[31:0]  = {32{ unalign2_ls2_i2                           }} & va_ls2_a1[31:0]
                                      | {32{~unalign2_ls2_i2 & is_ls_srca_v_ls2_i2[0]}} & is_ls_srca_data_ls2_i2[31:0];

  assign agu_addend_a_ls2_i2[63:32] = {32{ unalign2_ls2_i2                                                                                                 }} & va_ls2_a1[63:32]
                                      | {32{~unalign2_ls2_i2 & is_ls_srca_v_ls2_i2[1] & (~cpsr_aarch32 | tmo_inject_val_ls2_i2 | spe_inject_val_ls2_i2 | tbe_inject_val_ls2_i2)}} & is_ls_srca_data_ls2_i2[63:32];


  assign srcb_sel_no_shift_ls2_i2   =   is_ls_srcb_v_ls2_i2[0] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_NO_SH)    & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;
  assign srcb_sel_shift1_ls2_i2     =   is_ls_srcb_v_ls2_i2[0] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH1)      & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;  
  assign srcb_sel_shift2_ls2_i2     =   is_ls_srcb_v_ls2_i2[0] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH2)      & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;
  assign srcb_sel_shift3_ls2_i2     =   is_ls_srcb_v_ls2_i2[0] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_SH]  == `RV_BC_SRCB_SH3)      & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;

  assign srcb_sel_no_ext_ls2_i2     =                            ( (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_NO_EXT)
                                                                   | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)) & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;

  assign srcb_sel_sext_ls2_i2       =   is_ls_srcb_v_ls2_i2[0] & (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_SEXT)     & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;

  assign carry_in_ls2_i2            =                              (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_SRCB_EXT] == `RV_BC_SRCB_CARRYIN)  & ~unalign2_ls2_i2 & ~address_inject_val_ls2_i2_q;



  assign ls2_32byte_ld_st_cache_line_split_2nd_half_a1 = (ls2_fast_va_a1[5:4] != 2'b11 ) & uop_size_dec1_raw_ls2_a1_q[4] ; 
  assign unalign2_src_b_ls2_i2[31:0] = issue_st_val_ls2_a1_q & ls2_32byte_ld_st_cache_line_split_2nd_half_a1 ?  32'h20 : 32'h10 ; 

  assign agu_addend_b_ls2_i2[31:0]  = {32{unalign2_ls2_i2}}          & unalign2_src_b_ls2_i2[31:0] 
                                      | {32{srcb_sel_no_shift_ls2_i2}} &  is_ls_srcb_data_ls2_i2[31:0]
                                      | {32{srcb_sel_shift1_ls2_i2}}   & {is_ls_srcb_data_ls2_i2[30:0], 1'b0}
                                      | {32{srcb_sel_shift2_ls2_i2}}   & {is_ls_srcb_data_ls2_i2[29:0], 2'b0}
                                      | {32{srcb_sel_shift3_ls2_i2}}   & {is_ls_srcb_data_ls2_i2[28:0], 3'b0};

  assign agu_addend_b_ls2_i2[32]    =     srcb_sel_no_shift_ls2_i2   &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[32]
                                      |     srcb_sel_no_shift_ls2_i2   &  srcb_sel_sext_ls2_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift1_ls2_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift2_ls2_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[30]
                                      |     srcb_sel_shift3_ls2_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[29];

  assign agu_addend_b_ls2_i2[33]    =     srcb_sel_no_shift_ls2_i2   &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[33]
                                      |     srcb_sel_no_shift_ls2_i2   &  srcb_sel_sext_ls2_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift1_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[32]
                                      |     srcb_sel_shift1_ls2_i2     &  srcb_sel_sext_ls2_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift2_ls2_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift3_ls2_i2                                 & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[30];

  assign agu_addend_b_ls2_i2[34]    =     srcb_sel_no_shift_ls2_i2   &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[34]
                                      |    (srcb_sel_shift3_ls2_i2     |  srcb_sel_sext_ls2_i2)  & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[31]
                                      |     srcb_sel_shift2_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[32]
                                      |     srcb_sel_shift1_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]   & is_ls_srcb_data_ls2_i2[33];

  assign agu_addend_b_ls2_i2[63:35] = {29{srcb_sel_no_shift_ls2_i2   &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]}} & is_ls_srcb_data_ls2_i2[63:35]
                                      | {29{srcb_sel_shift1_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]}} & is_ls_srcb_data_ls2_i2[62:34]
                                      | {29{srcb_sel_shift2_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]}} & is_ls_srcb_data_ls2_i2[61:33]
                                      | {29{srcb_sel_shift3_ls2_i2     &  srcb_sel_no_ext_ls2_i2 & ~cpsr_aarch32 & is_ls_srcb_v_ls2_i2[1]}} & is_ls_srcb_data_ls2_i2[60:32]
                                      |                                 {29{srcb_sel_sext_ls2_i2   & ~cpsr_aarch32                              & is_ls_srcb_data_ls2_i2[   31]}};

  assign srcb_eq_zero_ls2_i2[0] = ~unalign2_ls2_i2 & ~is_ls_srcb_v_ls2_i2[0] & ~carry_in_ls2_i2 
                                  | address_inject_val_ls2_i2_q;

  assign srcb_eq_zero_ls2_i2[1] = ~( is_ls_srcb_v_ls2_i2[1]
                                     | is_ls_srcb_v_ls2_i2[0] & srcb_sel_sext_ls2_i2 & is_ls_srcb_data_ls2_i2[31])    
                                  |  unalign2_ls2_i2 
                                  |  address_inject_val_ls2_i2_q
                                  |  cpsr_aarch32;

  assign srca_hi_eq_zero_ls2_i2 = ~(is_ls_srca_v_ls2_i2[1] | unalign2_ls2_i2) 
                                  |  (cpsr_aarch32 & ~address_inject_val_ls2_i2_q);

  assign srca_v_ls2_i2          = is_ls_srca_v_ls2_i2[0] | unalign2_ls2_i2;

  assign agu_addend_a_en_ls2_i2[0] = (   issue_v_ls2_i2_q
                                        &  (  is_ls_srca_v_ls2_i2[0]
                                             | invdbg_ok                                      
                                           )
                                       )
                                     |  unalign2_ls2_i2;


  assign agu_addend_a_en_ls2_i2[1] = ( issue_v_ls2_i2_q
                                       &  (  is_ls_srca_v_ls2_i2[1]
                                          | ~srca_hi_eq_zero_ls2_a1_q))                       
                                     |  unalign2_ls2_i2;

  assign agu_addend_b_en_ls2_i2[0] = ( issue_v_ls2_i2_q
                                       &  (  is_ls_srcb_v_ls2_i2[0]
                                          |  carry_in_ls2_i2
                                          | ~srcb_eq_zero_ls2_a1_q[0]                        
                                          | invdbg_ok                                           
                                          )
                                        )
                                     |  unalign2_ls2_i2;

  assign agu_addend_b_en_ls2_i2[1] = ( issue_v_ls2_i2_q
                                       &  (  is_ls_srcb_v_ls2_i2[1]
                                          |  is_ls_srcb_v_ls2_i2[0] & srcb_sel_sext_ls2_i2 
                                          |  issue_cancel_ls2_i2_dly_q                       
                                          | ~srcb_eq_zero_ls2_a1_q[1]))                      
                                     |  unalign2_ls2_i2;


  assign st_pf_vld_ls2_i2 = ~address_inject_val_ls2_i2_q & ~(
                             | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_TYPE_ATOMIC] )
                             | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STREX )
                             | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] ==  `RV_BC_LS_TYPE_STLXR )
                             | ls_ctl_format_ls2_i2); 



  assign agu_addend_a_dup_en_ls2_i2 = ( issue_v_ls2_i2_q & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q & ~unalign2_ls2_i2
                                        &  (  is_ls_srca_v_ls2_i2[0]))                       
                                      | (unalign2_ls2_i2 & issue_ld_val_ls2_a1)
                                      | ((issue_v_ls2_i2_q | unalign2_ls2_i2) & (invdbg_ok |                         
                                                                                     rst_full_ls2_q & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls2_i2));     
  assign agu_addend_b_dup_en_ls2_i2 = ( issue_v_ls2_i2_q & ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & ~address_inject_val_ls2_i2_q & ~unalign2_ls2_i2
                                        &  (  is_ls_srcb_v_ls2_i2[0]
                                           |  carry_in_ls2_i2
                                           | ~srcb_eq_zero_dup_ls2_a1_q))                        
                                      | (unalign2_ls2_i2 & issue_ld_val_ls2_a1)
                                      | ((issue_v_ls2_i2_q | unalign2_ls2_i2) & (invdbg_ok | 
                                                                                      rst_full_ls2_q & ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_STORE] & st_pf_vld_ls2_i2));     


  always_ff @(posedge clk_agu2)
  begin: u_uop_size_dec1_raw_ls2_a1_q_4_0
    if (issue_v_poss_ls2_i2 == 1'b1)
      uop_size_dec1_raw_ls2_a1_q[4:0] <= `RV_BC_DFF_DELAY uop_size_dec1_raw_ls2_i2[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      uop_size_dec1_raw_ls2_a1_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_srca_v_ls2_a1_q
    if (issue_v_poss_ls2_i2 == 1'b1)
      srca_v_ls2_a1_q <= `RV_BC_DFF_DELAY srca_v_ls2_i2;
`ifdef RV_BC_XPROP_FLOP
    else if (issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      srca_v_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_issue_cancel_ls2_i2_dly_q
    if (reset_i == 1'b1)
      issue_cancel_ls2_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && issue_v_poss_ls2_i2 == 1'b1)
      issue_cancel_ls2_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls2_i2;
    else if (reset_i == 1'b0 && issue_v_poss_ls2_i2 == 1'b0)
    begin
    end
    else
      issue_cancel_ls2_i2_dly_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (issue_v_poss_ls2_i2 == 1'b1)
      issue_cancel_ls2_i2_dly_q <= `RV_BC_DFF_DELAY issue_cancel_ls2_i2;
`endif
  end



  always_ff @(posedge clk_agu2)
  begin: u_agu_addend_a_ls2_a1_q_31_0
    if (agu_addend_a_en_ls2_i2[0] == 1'b1)
      agu_addend_a_ls2_a1_q[31:0] <= `RV_BC_DFF_DELAY agu_addend_a_ls2_i2[31:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls2_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls2_a1_q[31:0] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_agu_addend_a_ls2_a1_q_63_32
    if (agu_addend_a_en_ls2_i2[1] == 1'b1)
      agu_addend_a_ls2_a1_q[63:32] <= `RV_BC_DFF_DELAY agu_addend_a_ls2_i2[63:32];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_a_en_ls2_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_a_ls2_a1_q[63:32] <= `RV_BC_DFF_DELAY {32{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_srca_hi_eq_zero_ls2_a1_q
    if (reset_i == 1'b1)
      srca_hi_eq_zero_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_a_en_ls2_i2[0] == 1'b1)
      srca_hi_eq_zero_ls2_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls2_i2;
    else if (reset_i == 1'b0 && agu_addend_a_en_ls2_i2[0] == 1'b0)
    begin
    end
    else
      srca_hi_eq_zero_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_a_en_ls2_i2[0] == 1'b1)
      srca_hi_eq_zero_ls2_a1_q <= `RV_BC_DFF_DELAY srca_hi_eq_zero_ls2_i2;
`endif
  end



  always_ff @(posedge clk_agu2)
  begin: u_agu_addend_b_ls2_a1_q_34_0
    if (agu_addend_b_en_ls2_i2[0] == 1'b1)
      agu_addend_b_ls2_a1_q[34:0] <= `RV_BC_DFF_DELAY agu_addend_b_ls2_i2[34:0];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls2_i2[0] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls2_a1_q[34:0] <= `RV_BC_DFF_DELAY {35{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2)
  begin: u_agu_addend_b_ls2_a1_q_63_35
    if (agu_addend_b_en_ls2_i2[1] == 1'b1)
      agu_addend_b_ls2_a1_q[63:35] <= `RV_BC_DFF_DELAY agu_addend_b_ls2_i2[63:35];
`ifdef RV_BC_XPROP_FLOP
    else if (agu_addend_b_en_ls2_i2[1] == 1'b0)
    begin
    end
    else
      agu_addend_b_ls2_a1_q[63:35] <= `RV_BC_DFF_DELAY {29{1'bx}};
`endif
  end


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_srcb_eq_zero_ls2_a1_q_1
    if (reset_i == 1'b1)
      srcb_eq_zero_ls2_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && agu_addend_b_en_ls2_i2[1] == 1'b1)
      srcb_eq_zero_ls2_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls2_i2[1];
    else if (reset_i == 1'b0 && agu_addend_b_en_ls2_i2[1] == 1'b0)
    begin
    end
    else
      srcb_eq_zero_ls2_a1_q[1] <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (agu_addend_b_en_ls2_i2[1] == 1'b1)
      srcb_eq_zero_ls2_a1_q[1] <= `RV_BC_DFF_DELAY srcb_eq_zero_ls2_i2[1];
`endif
  end

  rv_bc_dffr #(.W(1))  u_srcb_eq_zero_ls2_0 (.q(srcb_eq_zero_ls2_a1_q[0]),         .din(srcb_eq_zero_ls2_i2[0]),         .clk(clk_agu2), .en(agu_addend_b_en_ls2_i2[0]), .reset(reset_i));
  rv_bc_dff  #(.W(1))  u_carry_in_ls2_0  (.q(carry_in_ls2_a1_q),                .din(carry_in_ls2_i2),                .clk(clk_agu2), .en(agu_addend_b_en_ls2_i2[0]));
  assign ls2_cin_0_a1 = carry_in_ls2_a1_q;

 assign srcb_eq_zero_ls2_a1[1:0] = srcb_eq_zero_ls2_a1_q[1:0];

  assign srcp_data_ls2_i2_en = issue_v_poss_ls2_i2 & is_ls_srcp_v_ls2_i2;

  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_srcp_data_ls2_a1_q_3_0
    if (reset_i == 1'b1)
      srcp_data_ls2_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && srcp_data_ls2_i2_en == 1'b1)
      srcp_data_ls2_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls2_i2[3:0];
    else if (reset_i == 1'b0 && srcp_data_ls2_i2_en == 1'b0)
    begin
    end
    else
      srcp_data_ls2_a1_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`else
    else if (srcp_data_ls2_i2_en == 1'b1)
      srcp_data_ls2_a1_q[3:0] <= `RV_BC_DFF_DELAY is_ls_srcp_data_ls2_i2[3:0];
`endif
  end


  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_a_ls2_1 (.q(agu_addend_a_dup_ls2_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_a_ls2_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu2), .en(agu_addend_a_dup_en_ls2_i2));
  rv_bc_dff  #(.W(`RV_BC_LS_VA_ALIAS_MSB+1)) u_addend_b_ls2_1 (.q(agu_addend_b_dup_ls2_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0]),   .din(agu_addend_b_ls2_i2[`RV_BC_LS_VA_ALIAS_MSB:0]),       .clk(clk_agu2), .en(agu_addend_b_dup_en_ls2_i2));
  rv_bc_dff  #(.W(1))                       u_carry_in_ls2_1  (.q(carry_in_dup_ls2_a1_q),                                  .din(carry_in_ls2_i2),                                      .clk(clk_agu2), .en(agu_addend_b_dup_en_ls2_i2));
  rv_bc_dffr #(.W(1))                       u_srcb_eq_zero_ls2_1 (.q(srcb_eq_zero_dup_ls2_a1_q),                              .din(srcb_eq_zero_ls2_i2[0]),                               .clk(clk_agu2), .en(agu_addend_b_dup_en_ls2_i2), .reset(reset_i));

  assign va_dup_ls2_a1[`RV_BC_LS_VA_ALIAS_MSB:0] = agu_addend_a_dup_ls2_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + agu_addend_b_dup_ls2_a1_q[`RV_BC_LS_VA_ALIAS_MSB:0] 
                                                    + { {`RV_BC_LS_VA_ALIAS_MSB{1'b0}}, carry_in_dup_ls2_a1_q};

  assign va_dup_ls2_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1] = va_ls2_a1[28:`RV_BC_LS_VA_ALIAS_MSB+1];


  assign {ls2_fast_cout11_a1, ls2_fast_va_a1[11:0]} = agu_addend_a_ls2_a1_q[11:0] + agu_addend_b_ls2_a1_q[11:0] + {{11{1'b0}}, ls2_cin_0_a1};


  assign {end_byte_carry_out_5_ls2_a1, end_byte_ls2_a1[5:0]}   = {1'b0, ls2_fast_va_a1[5:0]}     
                                                                   + {2'b0, uop_size_dec1_raw_ls2_a1_q[4:0]};

  assign end_byte_carry_out_2_ls2_a1 = uop_size_dec1_raw_ls2_a1_q[2] & (|ls2_fast_va_a1[2:0])
                                       | uop_size_dec1_raw_ls2_a1_q[1] &   ls2_fast_va_a1[2] & (|ls2_fast_va_a1[1:0])
                                       | uop_size_dec1_raw_ls2_a1_q[0] & (&ls2_fast_va_a1[2:0]);





  always_comb 
  begin: u_ls2_srca_hash_a1_raw
   ls2_srca_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls2_srca_hash_a1_raw[macro_i] = ls2_srca_hash_a1_raw[macro_i] ^ agu_addend_a_ls2_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls2_srcb_hash_a1_raw
   ls2_srcb_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls2_srcb_hash_a1_raw[macro_i] = ls2_srcb_hash_a1_raw[macro_i] ^ agu_addend_b_ls2_a1_q[macro_j];
  end

  always_comb 
  begin: u_ls2_cin_hash_a1_raw
   ls2_cin_hash_a1_raw[5-1:0] = {5{1'b0}};
   for (integer macro_i=0; macro_i<5; macro_i=macro_i+1)
        for (integer macro_j=`RV_BC_LS_VA_ALIAS_MSB + 1 + macro_i; macro_j<=`RV_BC_LS_VA_MAX; macro_j=macro_j+5)
            ls2_cin_hash_a1_raw[macro_i] = ls2_cin_hash_a1_raw[macro_i] ^ ls2_cin_a1[macro_j];
  end





  assign ls2_srca_hash_final_a1[4:0] =  ls2_srca_hash_a1_raw[4:0]
                                                       ^ ls2_srcb_hash_a1_raw[4:0]           
                                                       ^ ls2_cin_hash_a1_raw[ 4:0];          


  always_ff @(posedge clk)
  begin: u_ls2_srca_hash_a2_q_4_0
    if (ld_val_ls2_a1 == 1'b1)
      ls2_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY ls2_srca_hash_final_a1[4:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ls2_srca_hash_a2_q[4:0] <= `RV_BC_DFF_DELAY {5{1'bx}};
`endif
  end




  assign ls2_srca_hash_a1[4:0] = (ls2_srca_hash_a1_raw[4:0] ^ ls2_srcb_hash_a1_raw[4:0]);

  assign cache_line_split_ls2_a1  = end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q; 

  assign ls2_cache_split1_val_a1 = ld_val_ls2_a1 & cache_line_split_ls2_a1 & ~prevent_unalign_ls2_a1 & ~ls2_non_sized_a1;


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ls2_cache_split2_a1_q
    if (reset_i == 1'b1)
      ls2_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls2_cache_split1_val_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ls2_cache_split2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ls2_cache_split2_a1_q <= `RV_BC_DFF_DELAY ls2_cache_split1_val_a1;
`endif
  end


  assign {uop_32b_low_end_byte_carry_out_5_ls2_a1, uop_32b_low_end_byte_ls2_a1[5:3]}   = {1'b0, ls2_fast_va_a1[5:3]}     
                                                                                     + {3'b0, uop_size_dec1_raw_ls2_a1_q[3]}
                                                                                     + {3'b0, end_byte_carry_out_2_ls2_a1};


  assign  end_byte_adjust_ls2_a1[3:0]   = unalign2_ls2_i2 ? 4'b1111 : end_byte_ls2_a1[3:0]; 
  assign  end_byte_adjust_ls2_a1[5:4]   = (unalign2_ls2_i2  | unalign2_ls2_a1_q) ? ls2_fast_va_a1[5:4] : end_byte_ls2_a1[5:4];


  assign  va_adjust_ls2_a1[3:0] = {4{~unalign2_ls2_a1_q}} & ls2_fast_va_a1[3:0];

  assign ls2_uop_cross_16_byte_a1 = (end_byte_ls2_a1[4] != ls2_fast_va_a1[4]);
  assign ls2_uop_cross_32_byte_a1 = (end_byte_ls2_a1[5] != ls2_fast_va_a1[5]);

  assign ls2_ld_cross_16_32_byte_a1 = ls2_uop_cross_16_byte_a1 | ls2_uop_cross_32_byte_a1;


  always_ff @(posedge clk)
  begin: u_ls2_ld_cross_16_32_byte_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      ls2_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY ls2_ld_cross_16_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ls2_ld_cross_16_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls2_ld_cross_32_byte_a2_q
    if (ld_val_ls2_a1 == 1'b1)
      ls2_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY ls2_uop_cross_32_byte_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_a1 == 1'b0)
    begin
    end
    else
      ls2_ld_cross_32_byte_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end



  assign ls2_uop_size_16byte_a1 =  ~uop_size_dec1_raw_ls2_a1_q[4] & (&uop_size_dec1_raw_ls2_a1_q[3:0]);
  assign ls2_uop_size_32byte_a1 = (&uop_size_dec1_raw_ls2_a1_q[4:0]);

  assign unalign_qw_split_ls2_a1  = &uop_size_dec1_raw_ls2_a1_q[3:0] & (|va_adjust_ls2_a1[1:0]);
  assign unalign_hw_split_ls2_a1  = 1'b0;
  assign ls2_non_sized_a1 = address_inject_val_ls2_a1_q
                            | ( (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                              & (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_CC_ATOMIC] == 4'b0011))           
                            | ls_ctl_format_ls2_a1;

  assign st_cache_line_split_ls2_a1  = end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q & ~ls2_non_sized_a1;

 
  assign st_low_cache_line_split_ls2_a1 = uop_32b_low_end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q            & ~ls2_non_sized_a1;
  assign st_mid_cache_line_split_ls2_a1 = ({uop_32b_low_end_byte_ls2_a1[5:3], end_byte_ls2_a1[2:0]} == 6'h3f)  & ~unalign2_ls2_a1_q & ~ls2_non_sized_a1 
                                          & ~(ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)  
                                          ;
  assign st_hi_cache_line_split_ls2_a1  = end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q & ~ls2_non_sized_a1 
                                          & ( (~uop_32b_low_end_byte_carry_out_5_ls2_a1 & ~({uop_32b_low_end_byte_ls2_a1[5:3], end_byte_ls2_a1[2:0]} == 6'h3f))
                                            | (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_STG)     
                                          );

  assign st_low_end_byte_ls2_a1[5:3] = uop_32b_low_end_byte_ls2_a1[5:3];

  assign page_split_ls2_a1   = end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q & (&ls2_fast_va_a1[11:6]) & ~ls2_non_sized_a1;

  assign ls2_page_split1_a1  = end_byte_carry_out_5_ls2_a1 & ~unalign2_ls2_a1_q & (&ls2_fast_va_a1[11:6]) & ~ls2_non_sized_a1;   

  assign ls2_ld_page_split1_a1 = ld_val_ls2_a1 & ls2_page_split1_a1;
  assign ls2_st_page_split1_a1 = issue_st_val_ls2_a1_q & ls2_page_split1_a1;
  assign ls2_page_split1_early_val_a1 = (ld_val_ls2_a1 | st_val_ls2_a1)  & ls2_page_split1_a1;
  assign ls2_page_split1_val_a1 = ls2_page_split1_early_val_a1 & ~prevent_unalign_ls2_a1;

  assign prevent_unalign_ls2_a1 = ls2_precommit_uop_i2_unqual & (lsx_precommit_uop_reject_cnt_q[1:0] == 2'b11)
                                  | address_inject_val_ls2_i2_q;


  assign unalign1_ls2_a1 = ( issue_ld_val_ls2_a1 & (cache_line_split_ls2_a1 | unalign_qw_split_ls2_a1 |  unalign_hw_split_ls2_a1)
                             | issue_st_val_ls2_a1 & page_split_ls2_a1) & ~unalign2_ls2_a1_q ;

  assign unalign2_ls2_i2       = unalign1_ls2_a1 & ~prevent_unalign_ls2_a1;
  assign reject_unalign_ls2_a1 = unalign1_ls2_a1 &  prevent_unalign_ls2_a1;





  assign  unalign2_arb_ld_ls0_i2 =   (issue_ld_val_ls0_a1 &  (cache_line_split_ls0_a1 | unalign_qw_split_ls0_a1 |  unalign_hw_split_ls0_a1)) & 
                                        ~prevent_unalign_ls0_a1;




  assign ls_is_uop_reject_ls0_i2 = ls_is_uop_reject_unalign_ls0_i2;


  
  assign word_aligned_ls0_a1      = ~|ls0_fast_va_a1[1:0]
                                    | ~|uop_size_dec1_raw_ls0_a1_q[3:1] & (~uop_size_dec1_raw_ls0_a1_q[0] | ~&ls0_fast_va_a1[1:0]);


  always_comb 
  begin: u_unshift_wv_ls0_a1_3_0
    casez({uop_size_dec1_raw_ls0_a1_q[3:0]})
      4'b00??: unshift_wv_ls0_a1[3:0] = 4'b0001;  
      4'b01??: unshift_wv_ls0_a1[3:0] = 4'b0011;  
      4'b1???: unshift_wv_ls0_a1[3:0] = 4'b1111;  
      default: unshift_wv_ls0_a1[3:0] = {4{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({uop_size_dec1_raw_ls0_a1_q[3:0]})) === 1'bx)
      unshift_wv_ls0_a1[3:0] = {4{1'bx}};
`endif
  end


  assign wv_qw_align_ls0_a1[7:0] = {4'b0, unshift_wv_ls0_a1[3:0]} << ls0_fast_va_a1[3:2];


  assign wv_qw_shift_ls0_a1[7:0] =   wv_qw_align_ls0_a1[7:0]
                                   |  {wv_qw_align_ls0_a1[6:0], 1'b0} & {8{~word_aligned_ls0_a1}};

  assign wv_cl_shift_ls0_a1[3:0]   = wv_qw_shift_ls0_a1[3:0] & {4{(ls0_fast_va_a1[5:4] == 2'b00)}};

  assign wv_cl_shift_ls0_a1[7:4]   = wv_qw_shift_ls0_a1[3:0] & {4{(ls0_fast_va_a1[5:4] == 2'b01)}}
                                     | wv_qw_shift_ls0_a1[7:4] & {4{(ls0_fast_va_a1[5:4] == 2'b00) & ~unalign_qw_split_ls0_a1}};

  assign wv_cl_shift_ls0_a1[11:8]  = wv_qw_shift_ls0_a1[3:0] & {4{(ls0_fast_va_a1[5:4] == 2'b10)}}
                                     | wv_qw_shift_ls0_a1[7:4] & {4{(ls0_fast_va_a1[5:4] == 2'b01) & ~unalign_qw_split_ls0_a1}};

  assign wv_cl_shift_ls0_a1[15:12] = wv_qw_shift_ls0_a1[3:0] & {4{(ls0_fast_va_a1[5:4] == 2'b11)}}
                                     | wv_qw_shift_ls0_a1[7:4] & {4{(ls0_fast_va_a1[5:4] == 2'b10) & ~unalign_qw_split_ls0_a1}};

  assign wv_cl_shift_ls0_a1[19:16] = wv_qw_shift_ls0_a1[7:4] & {4{cache_line_split_ls0_a1 | unalign_qw_split_ls0_a1}};


  always_comb 
  begin: u_wv_unalign_ls0_a1_15_0
    case(ls0_fast_va_a1[5:4])
      2'b00: wv_unalign_ls0_a1[15:0] = {12'b0, wv_nxt_cl_ls0_a2_q[3:0]};  
      2'b01: wv_unalign_ls0_a1[15:0] = {8'b0, wv_nxt_cl_ls0_a2_q[3:0], 4'b0};  
      2'b10: wv_unalign_ls0_a1[15:0] = {4'b0, wv_nxt_cl_ls0_a2_q[3:0], 8'b0};  
      2'b11: wv_unalign_ls0_a1[15:0] = {wv_nxt_cl_ls0_a2_q[3:0], 12'b0};  
      default: wv_unalign_ls0_a1[15:0] = {16{1'bx}};
    endcase
  end


  assign {wv_nxt_cl_ls0_a1[3:0], wv_ls0_a1[15:0]} = unalign2_ls0_a1_q ? {4'bxxxx, wv_unalign_ls0_a1[15:0]}
                                                                            : wv_cl_shift_ls0_a1[19:0];

  assign ls0_ld_unalign1_qual_a1 = unalign2_arb_ld_ls0_i2;  

  
  assign ls0_ld_unalign1_a1 = (cache_line_split_ls0_a1 | unalign_qw_split_ls0_a1); 

  always_ff @(posedge clk)
  begin: u_wv_nxt_cl_ls0_a2_q_3_0
    if (ls0_ld_unalign1_qual_a1 == 1'b1)
      wv_nxt_cl_ls0_a2_q[3:0] <= `RV_BC_DFF_DELAY wv_nxt_cl_ls0_a1[3:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls0_ld_unalign1_qual_a1 == 1'b0)
    begin
    end
    else
      wv_nxt_cl_ls0_a2_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`endif
  end



  assign two_bank_ld_ls0_a1    = &uop_size_dec1_raw_ls0_a1_q[3:0] ?                            
                                     ( ~unalign2_dup_ls0_a1_q & ~(va_dup_ls0_a1[3] & |va_dup_ls0_a1[2:0]) 
                                     | ~unalign2_dup_ls0_a1_q &  (va_dup_ls0_a1[2:0] == 3'b100)             
                                     |  unalign2_dup_ls0_a1_q & wv_nxt_cl_ls0_a2_q[2])              
                                   : (end_byte_carry_out_2_ls0_a1 & ~unalign2_dup_ls0_a1_q);        

  assign three_bank_ld_ls0_a1  =    &uop_size_dec1_raw_ls0_a1_q[3:0] 
                                   & ( ~unalign2_dup_ls0_a1_q & (va_dup_ls0_a1[2:0] == 3'b100));        

  assign adjust_va_ls0_a1[5:0] = { va_dup_ls0_a1[5:4], 
                                    (va_dup_ls0_a1[3:0] & {4{~unalign2_dup_ls0_a1_q}} )};

  assign ls0_p_a1[5:0]  = (agu_addend_a_dup_ls0_a1_q[5:0] ^ agu_addend_b_dup_ls0_a1_q[5:0]);
  assign ls0_g_a1[5:0]  = (agu_addend_a_dup_ls0_a1_q[5:0] & agu_addend_b_dup_ls0_a1_q[5:0]);

  assign ls0_bk_pg_1_0[1:0] = {(ls0_p_a1[1] & ls0_p_a1[0]), (ls0_g_a1[1] | ls0_g_a1[0] & ls0_p_a1[1])};
  assign ls0_bk_pg_2_1[1:0] = {(ls0_p_a1[2] & ls0_p_a1[1]), (ls0_g_a1[2] | ls0_p_a1[2] & ls0_g_a1[1])};
  assign ls0_bk_pg_3_2[1:0] = {(ls0_p_a1[3] & ls0_p_a1[2]), (ls0_g_a1[3] | ls0_g_a1[2] & ls0_p_a1[3])};
  assign ls0_bk_pg_4_3[1:0] = {(ls0_p_a1[4] & ls0_p_a1[3]), (ls0_g_a1[4] | ls0_p_a1[4] & ls0_g_a1[3])};

  assign ls0_bk_pg_4_1[1:0] = {(ls0_bk_pg_4_3[1] & ls0_bk_pg_2_1[1]), (ls0_bk_pg_4_3[0] | ls0_bk_pg_4_3[1] & ls0_bk_pg_2_1[0])};

  assign ls0_cout_a1[0] = carry_in_dup_ls0_a1_q & ls0_p_a1[0]      | ls0_g_a1[0];
  assign ls0_cout_a1[1] = carry_in_dup_ls0_a1_q & ls0_bk_pg_1_0[1] | ls0_bk_pg_1_0[0];
  assign ls0_cout_a1[2] = ls0_cout_a1[0]        & ls0_bk_pg_2_1[1] | ls0_bk_pg_2_1[0];
  assign ls0_cout_a1[3] = ls0_cout_a1[1]        & ls0_bk_pg_3_2[1] | ls0_bk_pg_3_2[0];
  assign ls0_cout_a1[4] = ls0_cout_a1[0]        & ls0_bk_pg_4_1[1] | ls0_bk_pg_4_1[0];
  assign ls0_cout_a1[5] = ls0_cout_a1[4]        & ls0_p_a1[5]      | ls0_g_a1[5];


  assign ls0_bnk_dec_needed_cin_0_a1[5:3] = { ls0_p_a1[5],  ls0_p_a1[4],  ls0_p_a1[3] & ~unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_1_a1[5:3] = { ls0_p_a1[5],  ls0_p_a1[4], ~ls0_p_a1[3] |  unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_2_a1[5:3] = { ls0_p_a1[5], ~ls0_p_a1[4],  ls0_p_a1[3] & ~unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_3_a1[5:3] = { ls0_p_a1[5], ~ls0_p_a1[4], ~ls0_p_a1[3] |  unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_4_a1[5:3] = {~ls0_p_a1[5],  ls0_p_a1[4],  ls0_p_a1[3] & ~unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_5_a1[5:3] = {~ls0_p_a1[5],  ls0_p_a1[4], ~ls0_p_a1[3] |  unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_6_a1[5:3] = {~ls0_p_a1[5], ~ls0_p_a1[4],  ls0_p_a1[3] & ~unalign2_dup_ls0_a1_q};
  assign ls0_bnk_dec_needed_cin_7_a1[5:3] = {~ls0_p_a1[5], ~ls0_p_a1[4], ~ls0_p_a1[3] |  unalign2_dup_ls0_a1_q};

  assign first_bank_dec_ld_ls0_a1[0] = (ls0_bnk_dec_needed_cin_0_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[1] = (ls0_bnk_dec_needed_cin_1_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[2] = (ls0_bnk_dec_needed_cin_2_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[3] = (ls0_bnk_dec_needed_cin_3_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[4] = (ls0_bnk_dec_needed_cin_4_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[5] = (ls0_bnk_dec_needed_cin_5_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[6] = (ls0_bnk_dec_needed_cin_6_a1[5:3] == ls0_cout_a1[4:2]);
  assign first_bank_dec_ld_ls0_a1[7] = (ls0_bnk_dec_needed_cin_7_a1[5:3] == ls0_cout_a1[4:2]);

  assign bank_dec_ld_ls0_a1[0] = first_bank_dec_ld_ls0_a1[0];
  assign bank_dec_ld_ls0_a1[1] = first_bank_dec_ld_ls0_a1[1] | first_bank_dec_ld_ls0_a1[0] & two_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[2] = first_bank_dec_ld_ls0_a1[2] | first_bank_dec_ld_ls0_a1[1] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[0] & three_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[3] = first_bank_dec_ld_ls0_a1[3] | first_bank_dec_ld_ls0_a1[2] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[1] & three_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[4] = first_bank_dec_ld_ls0_a1[4] | first_bank_dec_ld_ls0_a1[3] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[2] & three_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[5] = first_bank_dec_ld_ls0_a1[5] | first_bank_dec_ld_ls0_a1[4] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[3] & three_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[6] = first_bank_dec_ld_ls0_a1[6] | first_bank_dec_ld_ls0_a1[5] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[4] & three_bank_ld_ls0_a1;
  assign bank_dec_ld_ls0_a1[7] = first_bank_dec_ld_ls0_a1[7] | first_bank_dec_ld_ls0_a1[6] & two_bank_ld_ls0_a1 | first_bank_dec_ld_ls0_a1[5] & three_bank_ld_ls0_a1;



   assign ls0_thumb_instr_i2  =  ~ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_IL]
                                & ~(ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                & ~(ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG)
                                & ~(ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                & ~(ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                ;

  assign  ls0_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = {(ls0_thumb_instr_i2 ? is_ls_pc_ls0_i2[1] : is_ls_pc_ls0_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+2]),  is_ls_pc_ls0_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+1:2]};

   assign ls0_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = ls0_ld_vld_raw_haz_nuke_me_d4 | ls0_ld_vld_sb_fwd_lpt_alloc_d4 ? ls0_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0] :                            
                                                                                                               issue_ld_val_ls0_i2 ? ls0_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]   
                                                                                                                                     : ls0_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0];  

   assign ls0_pc_index_clken_a1 = issue_v_poss_ls0_i2 & (issue_ld_val_ls0_i2 | issue_st_val_ls0_i2 & ~rst_hit_count_sat);


  always_ff @(posedge clk_agu0 or posedge reset_i)
  begin: u_ls0_pc_index_a1_q_13_0
    if (reset_i == 1'b1)
      ls0_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && ls0_pc_index_clken_a1 == 1'b1)
      ls0_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls0_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
    else if (reset_i == 1'b0 && ls0_pc_index_clken_a1 == 1'b0)
    begin
    end
    else
      ls0_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`else
    else if (ls0_pc_index_clken_a1 == 1'b1)
      ls0_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls0_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`endif
  end


    assign ls0_lpt_cam_pc_index_clk_en_i2_d4 =    issue_ld_val_ls0_i2 
                                                  | ls0_ld_vld_raw_haz_nuke_me_d4
                                                  | ls0_ld_vld_sb_fwd_lpt_alloc_d4
                                                  | ls0_ld_vld_lpt_hit_d4;

   rv_bc_dff   #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls0_lpt_cam_pc_index_0 (.q(ls0_lpt_cam_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls0_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(ls0_lpt_cam_pc_index_clk_en_i2_d4));

   assign  lpt_cam_pc_index_l0_en_i2 =   ls0_lpt_cam_pc_index_clk_en_i2_d4  
                                         & any_lpt_valid_ent_21_to_max;            

   rv_bc_dff  #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls0_lpt_cam_pc_index_1 (.q(ls0_lpt_cam_pc_index_dup_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls0_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(lpt_cam_pc_index_l0_en_i2));


  always_ff @(posedge clk)
  begin: u_ls0_pc_index_a2_q_13_0
    if (ld_val_ls0_clken_a1 == 1'b1)
      ls0_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls0_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_clken_a1 == 1'b0)
    begin
    end
    else
      ls0_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls0_pf_trainable_type_a2_q
    if (ld_val_ls0_clken_a1 == 1'b1)
      ls0_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY ls0_pf_trainable_type_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls0_clken_a1 == 1'b0)
    begin
    end
    else
      ls0_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end

 

rv_bc_ccpass u_ccpass_ls0
  (
    .ccode     (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_CC_ATOMIC]),
    .apsr_nzcv (srcp_data_ls0_a1_q[3:0]),
    .ccpass    (raw_ccpass_ls0_a1)
  );


  assign issue_iciall_val_ls0_i2     =         issue_st_val_ls0_a1_din  
                                              &  (          ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_NON_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (   
                                                           (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0001) 
                                                         | (ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101) 
                                                       )
                                                     & (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b000     )
                                                     & (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b000     )
                                                 );

  assign issue_iciva_val_ls0_i2      =         issue_st_val_ls0_a1_din  
                                              &  (          ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101    ) 
                                                     & (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b011     )
                                                     & (    ls_uop_ctl_ls0_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b001     )
                                                 );


  assign issue_ici_val_ls0_i2  = (    issue_iciall_val_ls0_i2
                                      | issue_iciva_val_ls0_i2
                                   )
                                   & ~coh_icache_dis;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ici_val_ls0_a1_q
    if (reset_i == 1'b1)
      issue_ici_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      issue_ici_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls0_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ici_val_ls0_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      issue_ici_val_ls0_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls0_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ici_val_ls0_a2_q
    if (reset_i == 1'b1)
      ici_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b1)
      ici_val_ls0_a2_q <= `RV_BC_DFF_DELAY ici_val_ls0_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls0_i2_a2 == 1'b0)
    begin
    end
    else
      ici_val_ls0_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls0_i2_a2 == 1'b1)
      ici_val_ls0_a2_q <= `RV_BC_DFF_DELAY ici_val_ls0_a1;
`endif
  end


  assign ici_val_ls0_a1                     = unalign2_ls0_a1_q ?       ici_val_ls0_a2_q
                                                                    : issue_ici_val_ls0_a1_q;



  assign ccpass_ls0_a1 = (raw_ccpass_ls0_a1 | ls_ctl_format_ls0_a1 & (ls_uop_ctl_ls0_a1_q[`RV_BC_LS_CTL_TYPE] != `RV_BC_LS_TYPE_CLREX) | ~cpsr_aarch32 | ls_uop_ctl_ls0_a1_q[`RV_BC_LS_TYPE_ATOMIC]) & ~ici_val_ls0_a1;  





  assign  unalign2_arb_ld_ls1_i2 =   (issue_ld_val_ls1_a1 &  (cache_line_split_ls1_a1 | unalign_qw_split_ls1_a1 |  unalign_hw_split_ls1_a1)) & 
                                        ~prevent_unalign_ls1_a1;


  assign ls_is_uop_reject_unalign_ls1_i2 = issue_v_ls1_i2_q & unalign2_ls1_i2;  

  assign ls_is_uop_reject_ls1_i2 = ls_is_uop_reject_unalign_ls1_i2;


  
  assign word_aligned_ls1_a1      = ~|ls1_fast_va_a1[1:0]
                                    | ~|uop_size_dec1_raw_ls1_a1_q[3:1] & (~uop_size_dec1_raw_ls1_a1_q[0] | ~&ls1_fast_va_a1[1:0]);


  always_comb 
  begin: u_unshift_wv_ls1_a1_3_0
    casez({uop_size_dec1_raw_ls1_a1_q[3:0]})
      4'b00??: unshift_wv_ls1_a1[3:0] = 4'b0001;  
      4'b01??: unshift_wv_ls1_a1[3:0] = 4'b0011;  
      4'b1???: unshift_wv_ls1_a1[3:0] = 4'b1111;  
      default: unshift_wv_ls1_a1[3:0] = {4{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({uop_size_dec1_raw_ls1_a1_q[3:0]})) === 1'bx)
      unshift_wv_ls1_a1[3:0] = {4{1'bx}};
`endif
  end


  assign wv_qw_align_ls1_a1[7:0] = {4'b0, unshift_wv_ls1_a1[3:0]} << ls1_fast_va_a1[3:2];


  assign wv_qw_shift_ls1_a1[7:0] =   wv_qw_align_ls1_a1[7:0]
                                   |  {wv_qw_align_ls1_a1[6:0], 1'b0} & {8{~word_aligned_ls1_a1}};

  assign wv_cl_shift_ls1_a1[3:0]   = wv_qw_shift_ls1_a1[3:0] & {4{(ls1_fast_va_a1[5:4] == 2'b00)}};

  assign wv_cl_shift_ls1_a1[7:4]   = wv_qw_shift_ls1_a1[3:0] & {4{(ls1_fast_va_a1[5:4] == 2'b01)}}
                                     | wv_qw_shift_ls1_a1[7:4] & {4{(ls1_fast_va_a1[5:4] == 2'b00) & ~unalign_qw_split_ls1_a1}};

  assign wv_cl_shift_ls1_a1[11:8]  = wv_qw_shift_ls1_a1[3:0] & {4{(ls1_fast_va_a1[5:4] == 2'b10)}}
                                     | wv_qw_shift_ls1_a1[7:4] & {4{(ls1_fast_va_a1[5:4] == 2'b01) & ~unalign_qw_split_ls1_a1}};

  assign wv_cl_shift_ls1_a1[15:12] = wv_qw_shift_ls1_a1[3:0] & {4{(ls1_fast_va_a1[5:4] == 2'b11)}}
                                     | wv_qw_shift_ls1_a1[7:4] & {4{(ls1_fast_va_a1[5:4] == 2'b10) & ~unalign_qw_split_ls1_a1}};

  assign wv_cl_shift_ls1_a1[19:16] = wv_qw_shift_ls1_a1[7:4] & {4{cache_line_split_ls1_a1 | unalign_qw_split_ls1_a1}};


  always_comb 
  begin: u_wv_unalign_ls1_a1_15_0
    case(ls1_fast_va_a1[5:4])
      2'b00: wv_unalign_ls1_a1[15:0] = {12'b0, wv_nxt_cl_ls1_a2_q[3:0]};  
      2'b01: wv_unalign_ls1_a1[15:0] = {8'b0, wv_nxt_cl_ls1_a2_q[3:0], 4'b0};  
      2'b10: wv_unalign_ls1_a1[15:0] = {4'b0, wv_nxt_cl_ls1_a2_q[3:0], 8'b0};  
      2'b11: wv_unalign_ls1_a1[15:0] = {wv_nxt_cl_ls1_a2_q[3:0], 12'b0};  
      default: wv_unalign_ls1_a1[15:0] = {16{1'bx}};
    endcase
  end


  assign {wv_nxt_cl_ls1_a1[3:0], wv_ls1_a1[15:0]} = unalign2_ls1_a1_q ? {4'bxxxx, wv_unalign_ls1_a1[15:0]}
                                                                            : wv_cl_shift_ls1_a1[19:0];

  assign ls1_ld_unalign1_qual_a1 = unalign2_arb_ld_ls1_i2;  

  
  assign ls1_ld_unalign1_a1 = (cache_line_split_ls1_a1 | unalign_qw_split_ls1_a1); 

  always_ff @(posedge clk)
  begin: u_wv_nxt_cl_ls1_a2_q_3_0
    if (ls1_ld_unalign1_qual_a1 == 1'b1)
      wv_nxt_cl_ls1_a2_q[3:0] <= `RV_BC_DFF_DELAY wv_nxt_cl_ls1_a1[3:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls1_ld_unalign1_qual_a1 == 1'b0)
    begin
    end
    else
      wv_nxt_cl_ls1_a2_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`endif
  end



  assign two_bank_ld_ls1_a1    = &uop_size_dec1_raw_ls1_a1_q[3:0] ?                            
                                     ( ~unalign2_dup_ls1_a1_q & ~(va_dup_ls1_a1[3] & |va_dup_ls1_a1[2:0]) 
                                     | ~unalign2_dup_ls1_a1_q &  (va_dup_ls1_a1[2:0] == 3'b100)             
                                     |  unalign2_dup_ls1_a1_q & wv_nxt_cl_ls1_a2_q[2])              
                                   : (end_byte_carry_out_2_ls1_a1 & ~unalign2_dup_ls1_a1_q);        

  assign three_bank_ld_ls1_a1  =    &uop_size_dec1_raw_ls1_a1_q[3:0] 
                                   & ( ~unalign2_dup_ls1_a1_q & (va_dup_ls1_a1[2:0] == 3'b100));        

  assign adjust_va_ls1_a1[5:0] = { va_dup_ls1_a1[5:4], 
                                    (va_dup_ls1_a1[3:0] & {4{~unalign2_dup_ls1_a1_q}} )};

  assign ls1_p_a1[5:0]  = (agu_addend_a_dup_ls1_a1_q[5:0] ^ agu_addend_b_dup_ls1_a1_q[5:0]);
  assign ls1_g_a1[5:0]  = (agu_addend_a_dup_ls1_a1_q[5:0] & agu_addend_b_dup_ls1_a1_q[5:0]);

  assign ls1_bk_pg_1_0[1:0] = {(ls1_p_a1[1] & ls1_p_a1[0]), (ls1_g_a1[1] | ls1_g_a1[0] & ls1_p_a1[1])};
  assign ls1_bk_pg_2_1[1:0] = {(ls1_p_a1[2] & ls1_p_a1[1]), (ls1_g_a1[2] | ls1_p_a1[2] & ls1_g_a1[1])};
  assign ls1_bk_pg_3_2[1:0] = {(ls1_p_a1[3] & ls1_p_a1[2]), (ls1_g_a1[3] | ls1_g_a1[2] & ls1_p_a1[3])};
  assign ls1_bk_pg_4_3[1:0] = {(ls1_p_a1[4] & ls1_p_a1[3]), (ls1_g_a1[4] | ls1_p_a1[4] & ls1_g_a1[3])};

  assign ls1_bk_pg_4_1[1:0] = {(ls1_bk_pg_4_3[1] & ls1_bk_pg_2_1[1]), (ls1_bk_pg_4_3[0] | ls1_bk_pg_4_3[1] & ls1_bk_pg_2_1[0])};

  assign ls1_cout_a1[0] = carry_in_dup_ls1_a1_q & ls1_p_a1[0]      | ls1_g_a1[0];
  assign ls1_cout_a1[1] = carry_in_dup_ls1_a1_q & ls1_bk_pg_1_0[1] | ls1_bk_pg_1_0[0];
  assign ls1_cout_a1[2] = ls1_cout_a1[0]        & ls1_bk_pg_2_1[1] | ls1_bk_pg_2_1[0];
  assign ls1_cout_a1[3] = ls1_cout_a1[1]        & ls1_bk_pg_3_2[1] | ls1_bk_pg_3_2[0];
  assign ls1_cout_a1[4] = ls1_cout_a1[0]        & ls1_bk_pg_4_1[1] | ls1_bk_pg_4_1[0];
  assign ls1_cout_a1[5] = ls1_cout_a1[4]        & ls1_p_a1[5]      | ls1_g_a1[5];


  assign ls1_bnk_dec_needed_cin_0_a1[5:3] = { ls1_p_a1[5],  ls1_p_a1[4],  ls1_p_a1[3] & ~unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_1_a1[5:3] = { ls1_p_a1[5],  ls1_p_a1[4], ~ls1_p_a1[3] |  unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_2_a1[5:3] = { ls1_p_a1[5], ~ls1_p_a1[4],  ls1_p_a1[3] & ~unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_3_a1[5:3] = { ls1_p_a1[5], ~ls1_p_a1[4], ~ls1_p_a1[3] |  unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_4_a1[5:3] = {~ls1_p_a1[5],  ls1_p_a1[4],  ls1_p_a1[3] & ~unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_5_a1[5:3] = {~ls1_p_a1[5],  ls1_p_a1[4], ~ls1_p_a1[3] |  unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_6_a1[5:3] = {~ls1_p_a1[5], ~ls1_p_a1[4],  ls1_p_a1[3] & ~unalign2_dup_ls1_a1_q};
  assign ls1_bnk_dec_needed_cin_7_a1[5:3] = {~ls1_p_a1[5], ~ls1_p_a1[4], ~ls1_p_a1[3] |  unalign2_dup_ls1_a1_q};

  assign first_bank_dec_ld_ls1_a1[0] = (ls1_bnk_dec_needed_cin_0_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[1] = (ls1_bnk_dec_needed_cin_1_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[2] = (ls1_bnk_dec_needed_cin_2_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[3] = (ls1_bnk_dec_needed_cin_3_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[4] = (ls1_bnk_dec_needed_cin_4_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[5] = (ls1_bnk_dec_needed_cin_5_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[6] = (ls1_bnk_dec_needed_cin_6_a1[5:3] == ls1_cout_a1[4:2]);
  assign first_bank_dec_ld_ls1_a1[7] = (ls1_bnk_dec_needed_cin_7_a1[5:3] == ls1_cout_a1[4:2]);

  assign bank_dec_ld_ls1_a1[0] = first_bank_dec_ld_ls1_a1[0];
  assign bank_dec_ld_ls1_a1[1] = first_bank_dec_ld_ls1_a1[1] | first_bank_dec_ld_ls1_a1[0] & two_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[2] = first_bank_dec_ld_ls1_a1[2] | first_bank_dec_ld_ls1_a1[1] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[0] & three_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[3] = first_bank_dec_ld_ls1_a1[3] | first_bank_dec_ld_ls1_a1[2] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[1] & three_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[4] = first_bank_dec_ld_ls1_a1[4] | first_bank_dec_ld_ls1_a1[3] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[2] & three_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[5] = first_bank_dec_ld_ls1_a1[5] | first_bank_dec_ld_ls1_a1[4] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[3] & three_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[6] = first_bank_dec_ld_ls1_a1[6] | first_bank_dec_ld_ls1_a1[5] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[4] & three_bank_ld_ls1_a1;
  assign bank_dec_ld_ls1_a1[7] = first_bank_dec_ld_ls1_a1[7] | first_bank_dec_ld_ls1_a1[6] & two_bank_ld_ls1_a1 | first_bank_dec_ld_ls1_a1[5] & three_bank_ld_ls1_a1;



   assign ls1_thumb_instr_i2  =  ~ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_IL]
                                & ~(ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                & ~(ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG)
                                & ~(ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                & ~(ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                ;

  assign  ls1_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = {(ls1_thumb_instr_i2 ? is_ls_pc_ls1_i2[1] : is_ls_pc_ls1_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+2]),  is_ls_pc_ls1_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+1:2]};

   assign ls1_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = ls1_ld_vld_raw_haz_nuke_me_d4 | ls1_ld_vld_sb_fwd_lpt_alloc_d4 ? ls1_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0] :                            
                                                                                                               issue_ld_val_ls1_i2 ? ls1_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]   
                                                                                                                                     : ls1_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0];  

   assign ls1_pc_index_clken_a1 = issue_v_poss_ls1_i2 & (issue_ld_val_ls1_i2 | issue_st_val_ls1_i2 & ~rst_hit_count_sat);


  always_ff @(posedge clk_agu1 or posedge reset_i)
  begin: u_ls1_pc_index_a1_q_13_0
    if (reset_i == 1'b1)
      ls1_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && ls1_pc_index_clken_a1 == 1'b1)
      ls1_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls1_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
    else if (reset_i == 1'b0 && ls1_pc_index_clken_a1 == 1'b0)
    begin
    end
    else
      ls1_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`else
    else if (ls1_pc_index_clken_a1 == 1'b1)
      ls1_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls1_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`endif
  end


    assign ls1_lpt_cam_pc_index_clk_en_i2_d4 =    issue_ld_val_ls1_i2 
                                                  | ls1_ld_vld_raw_haz_nuke_me_d4
                                                  | ls1_ld_vld_sb_fwd_lpt_alloc_d4
                                                  | ls1_ld_vld_lpt_hit_d4;

   rv_bc_dff   #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls1_lpt_cam_pc_index_0 (.q(ls1_lpt_cam_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls1_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(ls1_lpt_cam_pc_index_clk_en_i2_d4));

   assign  lpt_cam_pc_index_l1_en_i2 =   ls1_lpt_cam_pc_index_clk_en_i2_d4  
                                         & any_lpt_valid_ent_21_to_max;            

   rv_bc_dff  #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls1_lpt_cam_pc_index_1 (.q(ls1_lpt_cam_pc_index_dup_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls1_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(lpt_cam_pc_index_l1_en_i2));


  always_ff @(posedge clk)
  begin: u_ls1_pc_index_a2_q_13_0
    if (ld_val_ls1_clken_a1 == 1'b1)
      ls1_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls1_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_clken_a1 == 1'b0)
    begin
    end
    else
      ls1_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls1_pf_trainable_type_a2_q
    if (ld_val_ls1_clken_a1 == 1'b1)
      ls1_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY ls1_pf_trainable_type_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls1_clken_a1 == 1'b0)
    begin
    end
    else
      ls1_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end

 

rv_bc_ccpass u_ccpass_ls1
  (
    .ccode     (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_CC_ATOMIC]),
    .apsr_nzcv (srcp_data_ls1_a1_q[3:0]),
    .ccpass    (raw_ccpass_ls1_a1)
  );


  assign issue_iciall_val_ls1_i2     =         issue_st_val_ls1_a1_din  
                                              &  (          ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_NON_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (   
                                                           (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0001) 
                                                         | (ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101) 
                                                       )
                                                     & (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b000     )
                                                     & (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b000     )
                                                 );

  assign issue_iciva_val_ls1_i2      =         issue_st_val_ls1_a1_din  
                                              &  (          ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101    ) 
                                                     & (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b011     )
                                                     & (    ls_uop_ctl_ls1_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b001     )
                                                 );


  assign issue_ici_val_ls1_i2  = (    issue_iciall_val_ls1_i2
                                      | issue_iciva_val_ls1_i2
                                   )
                                   & ~coh_icache_dis;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ici_val_ls1_a1_q
    if (reset_i == 1'b1)
      issue_ici_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      issue_ici_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls1_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ici_val_ls1_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      issue_ici_val_ls1_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls1_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ici_val_ls1_a2_q
    if (reset_i == 1'b1)
      ici_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b1)
      ici_val_ls1_a2_q <= `RV_BC_DFF_DELAY ici_val_ls1_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls1_i2_a2 == 1'b0)
    begin
    end
    else
      ici_val_ls1_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls1_i2_a2 == 1'b1)
      ici_val_ls1_a2_q <= `RV_BC_DFF_DELAY ici_val_ls1_a1;
`endif
  end


  assign ici_val_ls1_a1                     = unalign2_ls1_a1_q ?       ici_val_ls1_a2_q
                                                                    : issue_ici_val_ls1_a1_q;



  assign ccpass_ls1_a1 = (raw_ccpass_ls1_a1 | ls_ctl_format_ls1_a1 & (ls_uop_ctl_ls1_a1_q[`RV_BC_LS_CTL_TYPE] != `RV_BC_LS_TYPE_CLREX) | ~cpsr_aarch32 | ls_uop_ctl_ls1_a1_q[`RV_BC_LS_TYPE_ATOMIC]) & ~ici_val_ls1_a1;  





  assign  unalign2_arb_ld_ls2_i2 =   (issue_ld_val_ls2_a1 &  (cache_line_split_ls2_a1 | unalign_qw_split_ls2_a1 |  unalign_hw_split_ls2_a1)) & 
                                        ~prevent_unalign_ls2_a1;


  assign ls_is_uop_reject_unalign_ls2_i2 = issue_v_ls2_i2_q & unalign2_ls2_i2;  

  assign ls_is_uop_reject_ls2_i2 = ls_is_uop_reject_unalign_ls2_i2;


  
  assign word_aligned_ls2_a1      = ~|ls2_fast_va_a1[1:0]
                                    | ~|uop_size_dec1_raw_ls2_a1_q[3:1] & (~uop_size_dec1_raw_ls2_a1_q[0] | ~&ls2_fast_va_a1[1:0]);


  always_comb 
  begin: u_unshift_wv_ls2_a1_3_0
    casez({uop_size_dec1_raw_ls2_a1_q[3:0]})
      4'b00??: unshift_wv_ls2_a1[3:0] = 4'b0001;  
      4'b01??: unshift_wv_ls2_a1[3:0] = 4'b0011;  
      4'b1???: unshift_wv_ls2_a1[3:0] = 4'b1111;  
      default: unshift_wv_ls2_a1[3:0] = {4{1'bx}};
    endcase
`ifdef RV_BC_XPROP_CASE
    if((^({uop_size_dec1_raw_ls2_a1_q[3:0]})) === 1'bx)
      unshift_wv_ls2_a1[3:0] = {4{1'bx}};
`endif
  end


  assign wv_qw_align_ls2_a1[7:0] = {4'b0, unshift_wv_ls2_a1[3:0]} << ls2_fast_va_a1[3:2];


  assign wv_qw_shift_ls2_a1[7:0] =   wv_qw_align_ls2_a1[7:0]
                                   |  {wv_qw_align_ls2_a1[6:0], 1'b0} & {8{~word_aligned_ls2_a1}};

  assign wv_cl_shift_ls2_a1[3:0]   = wv_qw_shift_ls2_a1[3:0] & {4{(ls2_fast_va_a1[5:4] == 2'b00)}};

  assign wv_cl_shift_ls2_a1[7:4]   = wv_qw_shift_ls2_a1[3:0] & {4{(ls2_fast_va_a1[5:4] == 2'b01)}}
                                     | wv_qw_shift_ls2_a1[7:4] & {4{(ls2_fast_va_a1[5:4] == 2'b00) & ~unalign_qw_split_ls2_a1}};

  assign wv_cl_shift_ls2_a1[11:8]  = wv_qw_shift_ls2_a1[3:0] & {4{(ls2_fast_va_a1[5:4] == 2'b10)}}
                                     | wv_qw_shift_ls2_a1[7:4] & {4{(ls2_fast_va_a1[5:4] == 2'b01) & ~unalign_qw_split_ls2_a1}};

  assign wv_cl_shift_ls2_a1[15:12] = wv_qw_shift_ls2_a1[3:0] & {4{(ls2_fast_va_a1[5:4] == 2'b11)}}
                                     | wv_qw_shift_ls2_a1[7:4] & {4{(ls2_fast_va_a1[5:4] == 2'b10) & ~unalign_qw_split_ls2_a1}};

  assign wv_cl_shift_ls2_a1[19:16] = wv_qw_shift_ls2_a1[7:4] & {4{cache_line_split_ls2_a1 | unalign_qw_split_ls2_a1}};


  always_comb 
  begin: u_wv_unalign_ls2_a1_15_0
    case(ls2_fast_va_a1[5:4])
      2'b00: wv_unalign_ls2_a1[15:0] = {12'b0, wv_nxt_cl_ls2_a2_q[3:0]};  
      2'b01: wv_unalign_ls2_a1[15:0] = {8'b0, wv_nxt_cl_ls2_a2_q[3:0], 4'b0};  
      2'b10: wv_unalign_ls2_a1[15:0] = {4'b0, wv_nxt_cl_ls2_a2_q[3:0], 8'b0};  
      2'b11: wv_unalign_ls2_a1[15:0] = {wv_nxt_cl_ls2_a2_q[3:0], 12'b0};  
      default: wv_unalign_ls2_a1[15:0] = {16{1'bx}};
    endcase
  end


  assign {wv_nxt_cl_ls2_a1[3:0], wv_ls2_a1[15:0]} = unalign2_ls2_a1_q ? {4'bxxxx, wv_unalign_ls2_a1[15:0]}
                                                                            : wv_cl_shift_ls2_a1[19:0];

  assign ls2_ld_unalign1_qual_a1 = unalign2_arb_ld_ls2_i2;  

  
  assign ls2_ld_unalign1_a1 = (cache_line_split_ls2_a1 | unalign_qw_split_ls2_a1); 

  always_ff @(posedge clk)
  begin: u_wv_nxt_cl_ls2_a2_q_3_0
    if (ls2_ld_unalign1_qual_a1 == 1'b1)
      wv_nxt_cl_ls2_a2_q[3:0] <= `RV_BC_DFF_DELAY wv_nxt_cl_ls2_a1[3:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ls2_ld_unalign1_qual_a1 == 1'b0)
    begin
    end
    else
      wv_nxt_cl_ls2_a2_q[3:0] <= `RV_BC_DFF_DELAY {4{1'bx}};
`endif
  end



  assign two_bank_ld_ls2_a1    = &uop_size_dec1_raw_ls2_a1_q[3:0] ?                            
                                     ( ~unalign2_dup_ls2_a1_q & ~(va_dup_ls2_a1[3] & |va_dup_ls2_a1[2:0]) 
                                     | ~unalign2_dup_ls2_a1_q &  (va_dup_ls2_a1[2:0] == 3'b100)             
                                     |  unalign2_dup_ls2_a1_q & wv_nxt_cl_ls2_a2_q[2])              
                                   : (end_byte_carry_out_2_ls2_a1 & ~unalign2_dup_ls2_a1_q);        

  assign three_bank_ld_ls2_a1  =    &uop_size_dec1_raw_ls2_a1_q[3:0] 
                                   & ( ~unalign2_dup_ls2_a1_q & (va_dup_ls2_a1[2:0] == 3'b100));        

  assign adjust_va_ls2_a1[5:0] = { va_dup_ls2_a1[5:4], 
                                    (va_dup_ls2_a1[3:0] & {4{~unalign2_dup_ls2_a1_q}} )};

  assign ls2_p_a1[5:0]  = (agu_addend_a_dup_ls2_a1_q[5:0] ^ agu_addend_b_dup_ls2_a1_q[5:0]);
  assign ls2_g_a1[5:0]  = (agu_addend_a_dup_ls2_a1_q[5:0] & agu_addend_b_dup_ls2_a1_q[5:0]);

  assign ls2_bk_pg_1_0[1:0] = {(ls2_p_a1[1] & ls2_p_a1[0]), (ls2_g_a1[1] | ls2_g_a1[0] & ls2_p_a1[1])};
  assign ls2_bk_pg_2_1[1:0] = {(ls2_p_a1[2] & ls2_p_a1[1]), (ls2_g_a1[2] | ls2_p_a1[2] & ls2_g_a1[1])};
  assign ls2_bk_pg_3_2[1:0] = {(ls2_p_a1[3] & ls2_p_a1[2]), (ls2_g_a1[3] | ls2_g_a1[2] & ls2_p_a1[3])};
  assign ls2_bk_pg_4_3[1:0] = {(ls2_p_a1[4] & ls2_p_a1[3]), (ls2_g_a1[4] | ls2_p_a1[4] & ls2_g_a1[3])};

  assign ls2_bk_pg_4_1[1:0] = {(ls2_bk_pg_4_3[1] & ls2_bk_pg_2_1[1]), (ls2_bk_pg_4_3[0] | ls2_bk_pg_4_3[1] & ls2_bk_pg_2_1[0])};

  assign ls2_cout_a1[0] = carry_in_dup_ls2_a1_q & ls2_p_a1[0]      | ls2_g_a1[0];
  assign ls2_cout_a1[1] = carry_in_dup_ls2_a1_q & ls2_bk_pg_1_0[1] | ls2_bk_pg_1_0[0];
  assign ls2_cout_a1[2] = ls2_cout_a1[0]        & ls2_bk_pg_2_1[1] | ls2_bk_pg_2_1[0];
  assign ls2_cout_a1[3] = ls2_cout_a1[1]        & ls2_bk_pg_3_2[1] | ls2_bk_pg_3_2[0];
  assign ls2_cout_a1[4] = ls2_cout_a1[0]        & ls2_bk_pg_4_1[1] | ls2_bk_pg_4_1[0];
  assign ls2_cout_a1[5] = ls2_cout_a1[4]        & ls2_p_a1[5]      | ls2_g_a1[5];


  assign ls2_bnk_dec_needed_cin_0_a1[5:3] = { ls2_p_a1[5],  ls2_p_a1[4],  ls2_p_a1[3] & ~unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_1_a1[5:3] = { ls2_p_a1[5],  ls2_p_a1[4], ~ls2_p_a1[3] |  unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_2_a1[5:3] = { ls2_p_a1[5], ~ls2_p_a1[4],  ls2_p_a1[3] & ~unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_3_a1[5:3] = { ls2_p_a1[5], ~ls2_p_a1[4], ~ls2_p_a1[3] |  unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_4_a1[5:3] = {~ls2_p_a1[5],  ls2_p_a1[4],  ls2_p_a1[3] & ~unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_5_a1[5:3] = {~ls2_p_a1[5],  ls2_p_a1[4], ~ls2_p_a1[3] |  unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_6_a1[5:3] = {~ls2_p_a1[5], ~ls2_p_a1[4],  ls2_p_a1[3] & ~unalign2_dup_ls2_a1_q};
  assign ls2_bnk_dec_needed_cin_7_a1[5:3] = {~ls2_p_a1[5], ~ls2_p_a1[4], ~ls2_p_a1[3] |  unalign2_dup_ls2_a1_q};

  assign first_bank_dec_ld_ls2_a1[0] = (ls2_bnk_dec_needed_cin_0_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[1] = (ls2_bnk_dec_needed_cin_1_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[2] = (ls2_bnk_dec_needed_cin_2_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[3] = (ls2_bnk_dec_needed_cin_3_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[4] = (ls2_bnk_dec_needed_cin_4_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[5] = (ls2_bnk_dec_needed_cin_5_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[6] = (ls2_bnk_dec_needed_cin_6_a1[5:3] == ls2_cout_a1[4:2]);
  assign first_bank_dec_ld_ls2_a1[7] = (ls2_bnk_dec_needed_cin_7_a1[5:3] == ls2_cout_a1[4:2]);

  assign bank_dec_ld_ls2_a1[0] = first_bank_dec_ld_ls2_a1[0];
  assign bank_dec_ld_ls2_a1[1] = first_bank_dec_ld_ls2_a1[1] | first_bank_dec_ld_ls2_a1[0] & two_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[2] = first_bank_dec_ld_ls2_a1[2] | first_bank_dec_ld_ls2_a1[1] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[0] & three_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[3] = first_bank_dec_ld_ls2_a1[3] | first_bank_dec_ld_ls2_a1[2] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[1] & three_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[4] = first_bank_dec_ld_ls2_a1[4] | first_bank_dec_ld_ls2_a1[3] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[2] & three_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[5] = first_bank_dec_ld_ls2_a1[5] | first_bank_dec_ld_ls2_a1[4] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[3] & three_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[6] = first_bank_dec_ld_ls2_a1[6] | first_bank_dec_ld_ls2_a1[5] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[4] & three_bank_ld_ls2_a1;
  assign bank_dec_ld_ls2_a1[7] = first_bank_dec_ld_ls2_a1[7] | first_bank_dec_ld_ls2_a1[6] & two_bank_ld_ls2_a1 | first_bank_dec_ld_ls2_a1[5] & three_bank_ld_ls2_a1;



   assign ls2_thumb_instr_i2  =  ~ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_IL]
                                & ~(ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDPX)
                                & ~(ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_LDG)
                                & ~(ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_GATHER_LD)
                                & ~(ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_SVE_SCATTER_ST)
                                ;

  assign  ls2_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = {(ls2_thumb_instr_i2 ? is_ls_pc_ls2_i2[1] : is_ls_pc_ls2_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+2]),  is_ls_pc_ls2_i2[`RV_BC_LS_LPT_PC_INDEX_MAX+1:2]};

   assign ls2_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0] = ls2_ld_vld_raw_haz_nuke_me_d4 | ls2_ld_vld_sb_fwd_lpt_alloc_d4 ? ls2_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0] :                            
                                                                                                               issue_ld_val_ls2_i2 ? ls2_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]   
                                                                                                                                     : ls2_pc_index_d4[`RV_BC_LS_LPT_PC_INDEX_MAX:0];  

   assign ls2_pc_index_clken_a1 = issue_v_poss_ls2_i2 & (issue_ld_val_ls2_i2 | issue_st_val_ls2_i2 & ~rst_hit_count_sat);


  always_ff @(posedge clk_agu2 or posedge reset_i)
  begin: u_ls2_pc_index_a1_q_13_0
    if (reset_i == 1'b1)
      ls2_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && ls2_pc_index_clken_a1 == 1'b1)
      ls2_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls2_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
    else if (reset_i == 1'b0 && ls2_pc_index_clken_a1 == 1'b0)
    begin
    end
    else
      ls2_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`else
    else if (ls2_pc_index_clken_a1 == 1'b1)
      ls2_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls2_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`endif
  end


    assign ls2_lpt_cam_pc_index_clk_en_i2_d4 =    issue_ld_val_ls2_i2 
                                                  | ls2_ld_vld_raw_haz_nuke_me_d4
                                                  | ls2_ld_vld_sb_fwd_lpt_alloc_d4
                                                  | ls2_ld_vld_lpt_hit_d4;

   rv_bc_dff   #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls2_lpt_cam_pc_index_0 (.q(ls2_lpt_cam_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls2_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(ls2_lpt_cam_pc_index_clk_en_i2_d4));

   assign  lpt_cam_pc_index_l2_en_i2 =   ls2_lpt_cam_pc_index_clk_en_i2_d4  
                                         & any_lpt_valid_ent_21_to_max;            

   rv_bc_dff  #(.W(`RV_BC_LS_LPT_PC_INDEX_MAX+1)) u_ls2_lpt_cam_pc_index_1 (.q(ls2_lpt_cam_pc_index_dup_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),   .din(ls2_lpt_cam_pc_index_i2[`RV_BC_LS_LPT_PC_INDEX_MAX:0]),    .clk(clk), .en(lpt_cam_pc_index_l2_en_i2));


  always_ff @(posedge clk)
  begin: u_ls2_pc_index_a2_q_13_0
    if (ld_val_ls2_clken_a1 == 1'b1)
      ls2_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY ls2_pc_index_a1_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0];
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_clken_a1 == 1'b0)
    begin
    end
    else
      ls2_pc_index_a2_q[`RV_BC_LS_LPT_PC_INDEX_MAX:0] <= `RV_BC_DFF_DELAY {14{1'bx}};
`endif
  end


  always_ff @(posedge clk)
  begin: u_ls2_pf_trainable_type_a2_q
    if (ld_val_ls2_clken_a1 == 1'b1)
      ls2_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY ls2_pf_trainable_type_a1;
`ifdef RV_BC_XPROP_FLOP
    else if (ld_val_ls2_clken_a1 == 1'b0)
    begin
    end
    else
      ls2_pf_trainable_type_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`endif
  end

 

rv_bc_ccpass u_ccpass_ls2
  (
    .ccode     (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_CC_ATOMIC]),
    .apsr_nzcv (srcp_data_ls2_a1_q[3:0]),
    .ccpass    (raw_ccpass_ls2_a1)
  );


  assign issue_iciall_val_ls2_i2     =         issue_st_val_ls2_a1_din  
                                              &  (          ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_NON_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (   
                                                           (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0001) 
                                                         | (ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101) 
                                                       )
                                                     & (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b000     )
                                                     & (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b000     )
                                                 );

  assign issue_iciva_val_ls2_i2      =         issue_st_val_ls2_a1_din  
                                              &  (          ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_TYPE] == `RV_BC_LS_TYPE_VA_CMO )
                                              &  (
                                                       (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_CRN]  == 1'b1       )
                                                     & (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_CRM]  == 4'b0101    ) 
                                                     & (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_OP1]  == 3'b011     )
                                                     & (    ls_uop_ctl_ls2_i2_q[`RV_BC_LS_CTL_OP2]  == 3'b001     )
                                                 );


  assign issue_ici_val_ls2_i2  = (    issue_iciall_val_ls2_i2
                                      | issue_iciva_val_ls2_i2
                                   )
                                   & ~coh_icache_dis;



  always_ff @(posedge clk or posedge reset_i)
  begin: u_issue_ici_val_ls2_a1_q
    if (reset_i == 1'b1)
      issue_ici_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      issue_ici_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls2_i2;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      issue_ici_val_ls2_a1_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      issue_ici_val_ls2_a1_q <= `RV_BC_DFF_DELAY issue_ici_val_ls2_i2;
`endif
  end


  always_ff @(posedge clk or posedge reset_i)
  begin: u_ici_val_ls2_a2_q
    if (reset_i == 1'b1)
      ici_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'b0}};
`ifdef RV_BC_XPROP_FLOP
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b1)
      ici_val_ls2_a2_q <= `RV_BC_DFF_DELAY ici_val_ls2_a1;
    else if (reset_i == 1'b0 && any_issue_v_ls2_i2_a2 == 1'b0)
    begin
    end
    else
      ici_val_ls2_a2_q <= `RV_BC_DFF_DELAY {1{1'bx}};
`else
    else if (any_issue_v_ls2_i2_a2 == 1'b1)
      ici_val_ls2_a2_q <= `RV_BC_DFF_DELAY ici_val_ls2_a1;
`endif
  end


  assign ici_val_ls2_a1                     = unalign2_ls2_a1_q ?       ici_val_ls2_a2_q
                                                                    : issue_ici_val_ls2_a1_q;



  assign ccpass_ls2_a1 = (raw_ccpass_ls2_a1 | ls_ctl_format_ls2_a1 & (ls_uop_ctl_ls2_a1_q[`RV_BC_LS_CTL_TYPE] != `RV_BC_LS_TYPE_CLREX) | ~cpsr_aarch32 | ls_uop_ctl_ls2_a1_q[`RV_BC_LS_TYPE_ATOMIC]) & ~ici_val_ls2_a1;  










endmodule



`define RV_BC_UNDEFINE
`include "rv_bc_header.sv"
`include "rv_bc_ls_defines.sv"
`include "rv_bc_ls_params.sv"
`include "rv_bc_lsl2_defines.sv"
`undef RV_BC_UNDEFINE
