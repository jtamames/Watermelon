ui <- page_navbar(
  title = tags$img(
    src = paste0("data:image/png;base64,", WATERMELON_LOGO_B64),
    height = "52px",
    style = "margin: 2px 0;"
  ),
  theme = sqm_theme,
  navbar_options = navbar_options(theme = "light", bg = "#ffffff"),
  header = tagList(useShinyjs(), tags$head(tags$style(HTML(custom_css)))),
  nav_panel("Project",
    layout_sidebar(fillable = FALSE,
      sidebar = sidebar(width = 300, open = TRUE,
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Load mode"),
          radioButtons("load_mode", NULL,
            choices  = c("Load project" = "project", "Load tables" = "tables"),
            selected = "project", inline = TRUE)),
        uiOutput("project_dir_ui"),
        uiOutput("project_info_ui"), uiOutput("manual_tables_ui"),
        actionButton("load_project", "Load", class = "btn-primary w-100 mb-2"),
        uiOutput("project_status_ui")
      ),
      tags$div(style = "padding: 1rem;", uiOutput("project_summary_ui"))
    )
  ),
  nav_panel("Plots",
    layout_sidebar(
      sidebar = sidebar(width = 250,
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Category"),
          uiOutput("plot_category_ui")
        ),
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Plot type"),
          uiOutput("plot_type_ui")
        ),
        uiOutput("plot_controls_ui"),
        tags$div(style = "margin-top:5px;",
        uiOutput("plot_sample_selector_ui")),
        uiOutput("plot_download_ui")
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("Visualization"), uiOutput("plot_status_badge"))),
        card_body(class = "p-2",
          # ── Format bar: taxonomy controls (hidden by default) ──
          tags$div(id = "fmt_tax",
            style = "display:none;",
            tags$div(
              style = "display:flex; gap:8px; align-items:center; margin-bottom:6px; flex-wrap:wrap; padding:2px;",
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "W:"),
              numericInput("tax_plot_width",  NULL, value=1200, min=400, max=4000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "H:"),
              numericInput("tax_plot_height", NULL, value=560,  min=200, max=3000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Font:"),
              numericInput("tax_font_size",   NULL, value=11,   min=6,   max=24,   step=1,  width="65px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Palette:"),
              selectInput("tax_palette", NULL,
                choices  = c("Paired","Set2","Set3","Dark2","Tableau10","Alphabet","Polychrome36"),
                selected = "Paired", width="110px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Label width:"),
              numericInput("tax_label_width", NULL, value=30, min=5, max=100, step=5, width="65px")
            )
          ),
          # ── Format bar: function controls (hidden by default) ──
          tags$div(id = "fmt_func",
            style = "display:none;",
            tags$div(
              style = "display:flex; gap:8px; align-items:center; margin-bottom:6px; flex-wrap:wrap; padding:2px;",
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "W:"),
              numericInput("func_plot_width",  NULL, value=1200, min=400, max=4000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "H:"),
              numericInput("func_plot_height", NULL, value=560,  min=200, max=3000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Font:"),
              numericInput("func_font_size",   NULL, value=11,   min=6,   max=24,   step=1,  width="65px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Palette:"),
              selectInput("func_palette", NULL,
                choices  = c("Blues","Viridis","YlOrRd","RdBu","Greens","Hot","Portland","Jet"),
                selected = "Blues", width="100px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Label width:"),
              numericInput("func_label_width", NULL, value=40, min=10, max=200, step=5, width="65px")
            )
          ),
          # ── Format bar: taxonomy heatmap controls (hidden by default) ──
          tags$div(id = "fmt_tax_hm",
            style = "display:none;",
            tags$div(
              style = "display:flex; gap:8px; align-items:center; margin-bottom:6px; flex-wrap:wrap; padding:2px;",
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "W:"),
              numericInput("tax_hm_width",  NULL, value=1200, min=400, max=4000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "H:"),
              numericInput("tax_hm_height", NULL, value=560,  min=200, max=3000, step=50, width="80px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Font:"),
              numericInput("tax_hm_font",   NULL, value=11,   min=6,   max=24,   step=1,  width="65px"),
              tags$div(style="font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Palette:"),
              selectInput("tax_hm_palette", NULL,
                choices  = c("Blues","Viridis","YlOrRd","RdBu","Greens","Hot","Portland","Jet"),
                selected = "Blues", width="100px")
            )
          ),
          uiOutput("sqm_plot_ui")
        )
      )
    )
  ),
  nav_panel("Tables",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("tbl_category_ui"),
        tags$hr(class = "section-divider"),
        uiOutput("tbl_sub_controls_ui"),
        uiOutput("table_sample_filter"),
        tags$div(style = "margin-top:5px;",
          downloadButton("download_table", "Download CSV", class = "btn-outline-secondary w-100"))
      ),
      card(card_header("Data"), card_body(class = "p-2",
        uiOutput("tbl_main_ui")))
    )
  ),
  nav_panel("Krona",
    layout_sidebar(
      sidebar = sidebar(width = 250,
        uiOutput("krona_ktcheck_ui"),
        tags$hr(class = "section-divider"),
        tags$div(class = "form-label mt-1", "Filter samples"),
        uiOutput("krona_sample_filter_ui"),
        tags$hr(class = "section-divider"),
        actionButton("do_krona", "Generate Krona", class = "btn-primary w-100 mt-1"),
        tags$div(style = "margin-top:5px;", uiOutput("krona_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("krona_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("Krona Chart"), uiOutput("krona_badge_ui"))),
        card_body(class = "p-0", uiOutput("krona_view_ui"))
      )
    )
  ),
  nav_panel("Pathways",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("pw_pathview_check_ui"),
        tags$hr(class = "section-divider"),
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "KEGG Pathway"),
          uiOutput("pw_pathway_select_ui"),
          help_label("Count type", "Type of abundance measurement used for the ordination analysis"),
          uiOutput("pw_count_ui")
        ),
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Mode"),
          radioButtons("pw_mode", NULL,
            choices = c("All samples together" = "together",
                        "One per sample"       = "split",
                        "Fold-change"          = "foldchange"),
            selected = "together"),
          uiOutput("pw_foldchange_ui")
        ),
        tags$hr(class = "section-divider"),
        uiOutput("pw_sample_selector_ui"),

        tags$div(style = "margin-top:5px;", uiOutput("pw_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("pw_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("KEGG Pathway Map"), uiOutput("pw_badge_ui"))),
        card_body(class = "p-2", uiOutput("pw_view_ui"))
      )
    )
  ),
  nav_panel("Multivariate",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("mv_sidebar_controls"),
        tags$hr(class = "section-divider"),
        actionButton("do_pca", "Run analysis", class = "btn-primary w-100"),
        tags$script(HTML("
          (function() {
            // Inputs that, when changed, mark the analysis as stale
            var watchIds = [
              'mv_method','mv_data_type','mv_rank_db','mv_metric',
              'mv_norm','mv_dist','mv_n_features',
              'mv_exclude_unclassified','mv_exclude_ambiguous','mv_samples'
            ];
            var btn = document.getElementById('do_pca');
            function markStale() {
              if (!btn) btn = document.getElementById('do_pca');
              if (!btn) return;
              btn.classList.add('mv-stale');
            }
            function markFresh() {
              if (!btn) btn = document.getElementById('do_pca');
              if (!btn) return;
              btn.classList.remove('mv-stale');
            }
            // Watch Shiny input changes
            $(document).on('shiny:inputchanged', function(e) {
              if (watchIds.indexOf(e.name) !== -1) markStale();
              if (e.name === 'do_pca') markFresh();
            });
          })();
        ")),
        tags$div(style = "margin-top:5px;", uiOutput("mv_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("mv_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          uiOutput("mv_card_title_ui"), uiOutput("mv_badge_ui"))),
        card_body(class = "p-2",
          tags$div(
            style = "display:flex; gap:8px; align-items:center; margin-bottom:6px; flex-wrap:wrap; padding:2px;",
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "W:"),
            numericInput("mv_plot_width",  NULL, value = 700, min = 300, max = 1600, step = 50, width = "75px"),
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "H:"),
            numericInput("mv_plot_height", NULL, value = 500, min = 200, max = 1200, step = 50, width = "75px"),
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Font:"),
            numericInput("mv_font_size",   NULL, value = 11,  min = 6,   max = 24,   step = 1,  width = "65px"),
            uiOutput("mv_feat_labels_ui"),
            uiOutput("mv_ext_labels_ui"),
            uiOutput("mv_feat_style_ui")
          ),
          uiOutput("mv_plot_ui")
        )
      )
    )
  )
)
