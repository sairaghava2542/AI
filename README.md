     9  initialize_floorplan -core_utilization 0.7 -core_offset 10 -shape R
    10  set_block_pin_constraints  -allowed_layers {M3 M4 M5}
    11  place_pins -self
    12  set_boundary_cell_rules -left_boundary_cell saed32rvt_c/SHFILL1_RVT -right_boundary_cell saed32rvt_c/SHFILL1_RVT -top_boundary_cells saed32rvt_c/SHFILL1_RVT -bottom_boundary_cells saed32rvt_c/SHFILL1_RVT
    13  compile_boundary_cells
    14  save_block -as 2nd_floorplan
    15  create_net -power {VDD}
    16  create_net -ground {VSS}
    17  ## to connect power/ground_nets
    18  #
    19  connect_pg_net -all_blocks -automatic
    20  create_pg_ring_pattern core_ring_pattern -horizontal_layer M7 -horizontal_width 2.0 -horizontal_spacing 2.0 -vertical_layer M8 -vertical_width 2.0 -vertical_spacing 2.0
    21  set_pg_strategy core_power_ring -core -pattern {{name : core_ring_pattern}{nets : {VDD VSS}}{offset : {2 2}}}
    22  compile_pg -strategies core_power_ring
    23  create_pg_mesh_pattern mesh -layers { {{vertical_layer: M6}{width: 1} {spacing: interleaving}{pitch: 10} {offset: 1}} {{horizontal_layer: M7}{width: 1} {spacing: interleaving} {pitch: 10} {offset: 1}} {{vertical_layer: M8}{width: 1} {spacing: interleaving}{pitch: 10} {offset: 1}}}
    24  set_pg_strategy core_mesh -pattern { {pattern:mesh} {nets: VDD VSS}} -core -extension {stop: innermost_ring}
    25  compile_pg -strategies core_mesh
    26  create_pg_std_cell_conn_pattern std_cell_rail -layers {M1} -rail_width 0.06
    27  set_pg_strategy rail_strat -core -pattern {{name: std_cell_rail} {nets: VDD VSS} }
    28  compile_pg -strategies rail_strat
    29  check_drc
    30  check_pg_drc
    31  check_pg_connectivity
    32  check_pg_missing_vias
    33  check_pg_connectivity -check_std_cell_pins none
    34  set mode1 "func"
    35  set corner1 "nom"
    36  set scenario1 "${mode1}::${corner1}"
    37  remove_modes -all; remove_corners -all; remove_scenarios -all
    38  create_mode $mode1
    39  create_corner $corner1
    40  create_scenario -name func::nom -mode func -corner nom
    41  current_mode func
    42  current_scenario func::nom
    43  source ./../pnr/inputs/grid_mapped.sdc
    44  current_corner nom
    45  current_scenario func::nom
    46  set parasitic1 "p1"
    47  set tluplus_file$parasitic1 "/ve/po_home/b4m_sushanth_780/RTL_GDS2/ref/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus"
    48  set layer_map_file$parasitic1 "/ve/po_home/b4m_sushanth_780/RTL_GDS2/ref/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"
    49  set parasitic2 "p2"
    50  set tluplus_file$parasitic2 "/ve/po_home/b4m_sushanth_780/RTL_GDS2/ref/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus"
    51  set layer_map_file$parasitic2 "/ve/po_home/b4m_sushanth_780/RTL_GDS2/ref/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"
    52  read_parasitic_tech -tlup $tluplus_filep1 -layermap $layer_map_filep1 -name p1
    53  read_parasitic_tech -tlup $tluplus_filep2 -layermap $layer_map_filep2 -name p2
    54  set_parasitic_parameters -late_spec $parasitic1 -early_spec $parasitic2
    55  set_app_options -name place.coarse.continue_on_missing_scandef -value true
    56  place_pins -self
    57  place_opt
    58  legalize_placement
    59  report_timing -delay_type max
    60  report_timing -delay_type min
    61  save_block -as placement
    62  check_design -checks pre_clock_stree_stage
    63  check_design -checks pre_clock_tree_stage
    64  check_legality
    65  report_net_fanout *clk*
    66  set_app_options -name cts.common.max_fanout -value 130
    67  set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references -value true
    68  report_app_options clock_opt.flow.enable_ccd
    69  clock_opt
    70  clock_opt
    71  save_block -as clock_opt_done
    72  check_routes -antenna true
    73  his
