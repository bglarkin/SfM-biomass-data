# Theme BGL
# ————————————————————

theme_bgl = 
  theme_bw() +
  theme(
    plot.margin = unit(c(
	t = 2,
	r = 2,
	o = 4,
	b = 4
      ), "mm"),
    axis.title.x = element_text(
      size = 0,
      family = "Times",
      face = 1,
      margin = unit(c(
        t = 0,
        r = 0,
        o = 0,
        b = 0
      ), "mm")
    ),
    axis.title.y = element_text(
      size = 12,
      family = "Times",
      face = 1,
      margin = unit(c(
        t = 0,
        r = 4,
        o = 0,
        b = 0
      ), "mm")
    ),
    axis.text.x = element_text(
      size = 9,
      family = "Times",
      face = 1,
      margin = unit(c(
        t = 3,
        r = 0,
        o = 0,
        b = 0
      ), "mm")
    ),
    axis.text.y = element_text(
      size = 9,
      family = "Times",
      face = 1,
      margin = unit(c(
        t = 0,
        r = 3,
        o = 0,
        b = 0
      ), "mm")
    ),
    axis.ticks.length = unit(-2, "mm"),
    strip.text = element_text(
      size = 12,
      family = "Times",
      face = 2
    ),
    plot.caption = element_text(
      size = 8,
      family = "Times",
      face = 2
    ),
    plot.title = element_text(
      size = 14,
      family = "Times",
      face = 2
    ),
    text = element_text(family = "Times"),
    legend.text = element_text(
      size = 12,
      family = "Times",
      face = 1
    ),
    legend.title = element_text(
      size = 12,
      family = "Times",
      face = 1
    ),
    legend.position = "right",
    panel.grid = element_blank()
  ) 

