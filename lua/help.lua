--
-- I referenced the Drakipedia code for "Wings of Victory: Resolute Edition" by Mechanical/dwarftough
-- Thanks to them ;)
--

local T = wml.tag
local _ = wesnoth.textdomain 'wesnoth-The_Bees_Journey'

-- First, prepare WML

local dialog = {
	T.resolution {
		automatic_placement = true,
		maximum_width = 1024,
		maximum_height = 600,

		T.helptip { id = "tooltip_large" },
		T.tooltip { id = "tooltip_large" },

		T.grid {
			T.row {
				grow_factor = 1,
				T.column {
					border = "all", border_size = 5,
					horizontal_alignment = "left",
					T.label {
						id = "title", definition = "title",
						label = _"Campaign Help"
					}
				}
			},
			T.row {
				grow_factor = 1,
				T.column {
					horizontal_grow = true,
					vertical_grow = true,
					T.grid {
						T.row {
							T.column {
								grow_factor = 0,
								border = "all", border_size = 5,
								horizontal_grow = false,
								vertical_grow = true,
								T.tree_view {
									id = "treeview_topics",
									definition = "default",
									horizontal_scrollbar_mode = "never",
									vertical_scrollbar_mode = "never",
									indentation_step_size = 35,
									T.node {
										id = "category",
										T.node_definition {
											T.row {
												T.column {
													grow_factor = 0,
													border = "all", border_size = 5,
													horizontal_grow = true,
													T.toggle_button {
														id = "tree_view_node_toggle",
														definition = "tree_view_node"
													}
												},
												T.column {
													grow_factor = 1,
													horizontal_grow = true,
													T.toggle_panel {
														id = "tree_view_node_label",
														T.grid {
															T.row {
																T.column {
																	border = "all", border_size = 5,
																	horizontal_alignment = "left",
																	T.label {
																		id = "label_topic",
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							},
							T.column {
								grow_factor = 1,
								horizontal_grow = true,
								vertical_grow = true,
								T.multi_page {
									id = "details",
									definition = "default",
									horizontal_scrollbar_mode = "never",
									T.page_definition {
										id = "simple",
										T.row {
											T.column {
												border = "all", border_size = 5,
												horizontal_grow = true,
												vertical_grow = true,
												T.scroll_label {
													id = "label_content"
												}
											}
										}
									}
								}
							}
						}
					}
				}
			},
			T.row {
				T.column {
					horizontal_grow = true,
					T.grid {
						T.row {
							T.column {
								grow_factor = 1,
								T.spacer {}
							},
							T.column {
								border = "all", border_size = 5,
								horizontal_alignment = "right",
								T.button {
									id = "ok",
									label = _"Close"
								}
							}
						}
					}
				}
			}
		}
	}
}

-- Basic format setup

local function make_caption(text)
	return ("<big><b>%s</b></big>"):format(text)
end

--
-- Core: [show_campaign_help] tag
--

function wesnoth.wml_actions.show_campaign_help(cfg)
	local index_map = {}

	local preshow = function(dialog)
		local root_node = dialog:find("treeview_topics")
		local details = dialog:find("details")

		function gui.widget.add_help_page(parent_node, args)
			local node_type = "category"
			local page_type = "simple"

			local node = parent_node:add_item_of_type(node_type)
			local details_page = details:add_item_of_type(page_type)
			if args.title then
				node.label_topic.label = args.title
				node.unfolded = true
			end
			index_map[table.concat(node.path, "_")] = details.item_count
			return node, details_page
		end

		local add_page = function(caption, text)
			local node, page = root_node:add_help_page {
				title = caption
			}
			page.label_content.marked_up_text = make_caption(caption) .. "\n\n" .. text
		end

		-- Assorted formats

		local form_text = function(text)
			return text .. "\n\n"
		end
		local form_sect = function(sect, text)
			return "<b>" .. sect .. "</b>\n" .. text .. "\n\n"
		end
		local form_list = function(list, text)
			return "✦ " .. "<b>" .. list .. "</b>" .. ": " .. text .. "\n"
		end
		local form_scls = function(sect, list)
			return "<b>" .. sect .. "</b>\n" .. "✦ " .. list .. "\n\n"
		end

		--
		-- Help pages
		--

		add_page( _"Information",
			form_list( _"Campaign Title", _"The Bee’s Journey") ..
			form_list( _"Version", _"1.99.2 (Beta 2)") ..
			form_list( _"Recommended Wesnoth Version", _"1.19.17 or later")
		)
		add_page( _"Scenario Redesign Status",
			form_text( _"Intermediate level, 12 scenarios planned, currently 10 playable.") ..
			form_scls( _"Complete", "S0, S1, S2, S3, S4, S5, S6, S7, S8, S10") ..
			form_scls( _"Complete (except for map polishing)", "S9") ..
			form_scls( _"Work-in-Progress", "S11") ..
			form_scls( _"Pending", "S12, S12x, S12y") ..
			form_text( _"S9 and subsequent scenarios are scheduled to undergo fundamental revisions from earlier versions.")
		)
		add_page( _"Character AMLAs",
			form_text( _"Several characters (and possibly all player units eventually?) in this campaign have their respective AMLAs.") ..
			form_text( _"Still under construction ― I aim to make the list available here once ready.")
		)
		add_page( _"Items and Easter Eggs",
			form_text( _"List of all items and Easter eggs during the campaign.") ..
			form_scls( _"S2 ― Skirmish at Sea", _"You can earn gold for each enemy leader you defeat.") ..
			form_scls( _"S3 ― Honey Meets Darkness", _"There is a bow (12×3) beyond the swamp. It can be used by a unit except a drone.") ..
			form_scls( _"S4 ― To the Voyage", _"There is an allied elven lord (Clovis) hiding in one of the villages. Also, let Kaldyn head towards the lake.") ..
			form_scls( _"S5 ― Arrival at Lagos Island", _"There is an enemy soldier guarding the gold.") ..
			form_scls( _"S6 ― The Winter", _"There is an allied little caterpillar (Imorin) hiding in the lair.") ..
			form_scls( _"S7 ― Rescue the Ninjas", _"There is a ring that grants the skirmisher ability. Also, defeating Kushark with Dragochan grants a special bonus.") ..
			form_scls( _"S9 ― Reunion", _"Defeating the enemy leader grants a buckler usable from the next scenario on.") ..
			form_text( _"See also achievements.")
		)
		add_page( _"Feedback or Bug Reports",
			form_text( _"If you encounter any bugs or unnatural behavior, please report them to the author. Feedback (especially on game balance and prose) is also always welcome.") ..
			form_list( _"Wesnoth.org Forum Topic", "https://r.wesnoth.org/t60376") ..
			form_list( _"GitHub Issue Tracker", "https://github.com/aloneTurtle/The_Bees_Journey/issues") .. "\n" ..
			form_text( _"When posting, please indicate the campaign version you are playing.")
		)

		root_node:focus()

		function root_node.on_modified()
			local selected_index = index_map[table.concat(root_node.selected_item_path, '_')]
			if selected_index ~= nil then
				details.selected_index = selected_index
			end
		end
	end

	-- Finishing
	local dialog_wml = wml.get_child(dialog, 'resolution')
	gui.show_dialog(dialog_wml, preshow)
end
