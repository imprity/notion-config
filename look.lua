--
-- look_newviolet for Notion's default drawing engine.
-- Based on look_cleanviolet
--

if not gr.select_engine("de") then
    return
end

de.reset()

de.defstyle("*", {
    highlight_colour = "#e7e7ff",
    shadow_colour = "#e7e7ff",
    background_colour = "#b8b8c8",
    foreground_colour = "#000000",

    shadow_pixels = 1,
    highlight_pixels = 2,
    padding_pixels = 1,
    spacing = 1,
    border_style = "elevated",
    border_sides = "tb",

    font = "xft:Unifont:size=" .. tostring(local_settings.font_size),
    text_align = "center",
})


de.defstyle("tab", {
    font = "xft:Unifont:size=" .. tostring(local_settings.font_size),

    de.substyle("active-selected", {
        highlight_colour = "#aaaacc",
        shadow_colour = "#aaaacc",
        background_colour = "#666699",
        foreground_colour = "#eeeeee",
    }),

    de.substyle("inactive-selected", {
        highlight_colour = "#cfcfdf",
        shadow_colour = "#cfcfdf",
        background_colour = "#9999bb",
        foreground_colour = "#000000",
    }),
})


de.defstyle("input", {
    text_align = "left",
    highlight_colour = "#eeeeff",
    shadow_colour = "#eeeeff",

    de.substyle("*-selection", {
        background_colour = "#666699",
        foreground_colour = "#000000",
    }),

    de.substyle("*-cursor", {
        background_colour = "#000000",
        foreground_colour = "#b8b8c8",
    }),
})


de.defstyle("input-menu", {
    highlight_pixels = 0,
    shadow_pixels = 0,
    padding_pixels = 0,
})


de.defstyle("frame", {
    background_colour = "#000000",
    transparent_background = false,
    shadow_pixels = 1,
    highlight_pixels = 1,
    padding_pixels = 0,
    border_sides = "all",
    de.substyle("quasiactive", {
        -- Something detached from the frame is active
        padding_colour = "#901010",
    }),
})

de.defstyle("frame-tiled", {
    shadow_pixels = 0,
    highlight_pixels = 0,
    padding_pixels = 1,
})

de.defstyle("frame-tiled-alt", {
    bar = "none",
})

local bright_grey = "#f0f0f0"
local grey = "#cccccc"
local dark_grey = "#525252"

de.defstyle("frame-floating", {
    bar = "shaped",
    border_sides = "all",
    border_style = "ridge",

    padding_pixels = 4,
    highlight_pixels = 2,
    shadow_pixels = 3,

    de.substyle("active", {
        highlight_colour =  bright_grey,
        padding_colour   = grey,
        shadow_colour   = dark_grey,
    }),

    de.substyle("inactive", {
        highlight_colour =  bright_grey,
        padding_colour   = grey,
        shadow_colour   = dark_grey,
    }),
})

de.defstyle("tab-frame-floating", {
    border_sides = "lr",
    border_style = "elevated",

    padding_pixels = 3,
    highlight_pixels = 2,
    shadow_pixels = 3,

    background_colour = grey,
    foreground_colour = "#000000",

    highlight_colour =  bright_grey,
    padding_colour   = grey,
    shadow_colour   = dark_grey,

    de.substyle("active-selected", {
        highlight_colour =  bright_grey,
        padding_colour   = grey,
        shadow_colour   = dark_grey,

        background_colour = "#666699",
        foreground_colour = "#eeeeee",
    }),

    de.substyle("inactive-selected", {
        highlight_colour =  bright_grey,
        padding_colour   = grey,
        shadow_colour   = dark_grey,

        background_colour = grey,
        foreground_colour = "#000000",
    }),
})

de.defstyle("frame-transient", {
    bar = "none",
    padding_pixels = 1,
})


dopath("lookcommon_clean_stdisp")
dopath("lookcommon_clean_tab")

-- Refresh objects' brushes.
gr.refresh()
