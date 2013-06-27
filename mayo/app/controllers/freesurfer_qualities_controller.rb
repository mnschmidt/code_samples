class FreesurferQualitiesController < ApplicationController
  layout "standard"
  active_scaffold :freesurfer_quality do |config|
    config.list.columns = [:r_number, :all_segm_2d, :all_surf_2d, :all_pial_wm_surf_3d, :all_infl_surf_3d, :all_useable, :left_segm_2d, :left_surf_2d, :left_pial_wm_surf_3d, :left_infl_surf_3d, :left_useable, :right_segm_2d, :right_surf_2d, :right_pial_wm_surf_3d, :right_infl_surf_3d, :right_useable]
    config.create.columns = [:user, :all_segm_2d, :all_surf_2d, :all_pial_wm_surf_3d, :all_infl_surf_3d, :all_useable, :left_segm_2d, :left_surf_2d, :left_pial_wm_surf_3d, :left_infl_surf_3d, :left_useable, :right_segm_2d, :right_surf_2d, :right_pial_wm_surf_3d, :right_infl_surf_3d, :right_useable, :note, :created_by]
    config.update.columns = [:user, :all_segm_2d, :all_surf_2d, :all_pial_wm_surf_3d, :all_infl_surf_3d, :all_useable, :left_segm_2d, :left_surf_2d, :left_pial_wm_surf_3d, :left_infl_surf_3d, :left_useable, :right_segm_2d, :right_surf_2d, :right_pial_wm_surf_3d, :right_infl_surf_3d, :right_useable, :note, :created_by, :updated_by]
#    config.list.columns[:r_number].sort_by :sql => 'r_number'
    
    config.columns[:user_id].label = "Rater"
    config.columns[:all_segm_2d].label = "Seg (a)"
    config.columns[:all_surf_2d].label = "Surf (a)"
    config.columns[:all_pial_wm_surf_3d].label = "P/W surf (a)"
    config.columns[:all_infl_surf_3d].label = "Inflated surf (a)"
    config.columns[:all_useable].label = "Useable (a)"
    config.columns[:left_segm_2d].label = "Seg (l)"
    config.columns[:left_surf_2d].label = "Surf (l)"
    config.columns[:left_pial_wm_surf_3d].label = "P/W surf (l)"
    config.columns[:left_infl_surf_3d].label = "Inflated surf (l)"
    config.columns[:left_useable].label = "Useable (l)"
    config.columns[:right_segm_2d].label = "Seg (r)"
    config.columns[:right_surf_2d].label = "Surf (r)"
    config.columns[:right_pial_wm_surf_3d].label = "P/W surf (r)"
    config.columns[:right_infl_surf_3d].label = "Inflated surf (r)"
    config.columns[:right_useable].label = "Useable (r)"
    
    config.columns[:user].form_ui = :select
    config.columns[:all_segm_2d].form_ui = :select
    config.columns[:all_segm_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:all_surf_2d].form_ui = :select
    config.columns[:all_surf_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:all_pial_wm_surf_3d].form_ui = :select
    config.columns[:all_pial_wm_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:all_infl_surf_3d].form_ui = :select
    config.columns[:all_infl_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:all_useable].form_ui = :select
    config.columns[:all_useable].options = {:options => [[" - Unrated - ",777],["Yes",1],["No",2]]}
    config.columns[:left_segm_2d].form_ui = :select
    config.columns[:left_segm_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:left_surf_2d].form_ui = :select
    config.columns[:left_surf_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:left_pial_wm_surf_3d].form_ui = :select
    config.columns[:left_pial_wm_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:left_infl_surf_3d].form_ui = :select
    config.columns[:left_infl_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:left_useable].form_ui = :select
    config.columns[:left_useable].options = {:options => [[" - Unrated - ",777],["Yes",1],["No",2]]}
    config.columns[:right_segm_2d].form_ui = :select
    config.columns[:right_segm_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:right_surf_2d].form_ui = :select
    config.columns[:right_surf_2d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:right_pial_wm_surf_3d].form_ui = :select
    config.columns[:right_pial_wm_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:right_infl_surf_3d].form_ui = :select
    config.columns[:right_infl_surf_3d].options = {:options => [[" - Unrated - ",777],["Excellent",7],["Very good",6],["Good",5],["Sufficient",4],["Fair",3],["Poor",2],["Not constructed",1]]}
    config.columns[:right_useable].form_ui = :select
    config.columns[:right_useable].options = {:options => [[" - Unrated - ",777],["Yes",1],["No",2]]}
    config.list.per_page = 1000
  end
end
