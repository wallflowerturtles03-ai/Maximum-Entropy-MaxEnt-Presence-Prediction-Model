# ---- 0. Setup ---------------------------------------------------------------
# install.packages("terra")   # run once if needed
library(terra)

asc_dir <- "F:\\SE\\layers_asc"     # folder containing the .asc files
out_dir <- "F:\\SE\\figures"             # where the figures will be saved
dir.create(out_dir, showWarnings = FALSE)

# ---- 1. Layers: file name (without .asc) = panel title with units -----------
# Edit the names on the left if your files are named differently.
lyr <- c(
  bio02 = "Mean diurnal range, bio02 (°C)",
  bio04 = "Temperature seasonality, bio04 (SD × 100)",
  bio05 = "Max temp. of warmest month, bio05 (°C)",
  bio06 = "Min temp. of coldest month, bio06 (°C)",
  bio09 = "Mean temp. of driest quarter, bio09 (°C)",
  bio12 = "Annual precipitation, bio12 (mm)",
  bio14 = "Precip. of driest month, bio14 (mm)",
  bio15 = "Precip. seasonality, bio15 (CV)",
  bio18 = "Precip. of warmest quarter, bio18 (mm)",
  bio19 = "Precip. of coldest quarter, bio19 (mm)",
  elev  = "Elevation (m)",
  slope = "Slope (°)",
  ndvi  = "Mean NDVI, 2024 (unitless)"
)

files <- file.path(asc_dir, paste0(names(lyr), ".asc"))
stopifnot(all(file.exists(files)))     # stops if a file name is wrong

# rast() stacks the files and gives an error if the extent or
# resolution of any layer differs, which is a useful check in itself.
s <- rast(files)
names(s) <- names(lyr)

# .asc files carry no projection, so set it. Use the CRS you actually used
# (WGS84 for WorldClim at 30 arc-seconds).
crs(s) <- "EPSG:4326"

# ---- 2. Check that all layers match (for your report) -----------------------
print(s)         # dimensions, resolution, extent, CRS
res(s)           # should be ~0.008333 degrees (30 arc-seconds)
ext(s)
global(s, "min", na.rm = TRUE)   # watch for -9999 leaking in as real data
global(s, "max", na.rm = TRUE)

# ---- 3. Table of variables (min, max, mean) for your report -----------------
tab <- data.frame(
  Code        = names(s),
  Description = unname(lyr),
  Min  = round(global(s, "min",  na.rm = TRUE)[, 1], 2),
  Max  = round(global(s, "max",  na.rm = TRUE)[, 1], 2),
  Mean = round(global(s, "mean", na.rm = TRUE)[, 1], 2)
)
write.csv(tab, file.path(out_dir, "Table_variables.csv"), row.names = FALSE)

# ---- 4. Plotting function ---------------------------------------------------
plot_layers <- function(codes, file, nrow, ncol, w, h) {
  png(file, width = w, height = h, units = "in", res = 300)
  par(mfrow = c(nrow, ncol), cex.main = 0.8)

  for (k in codes) {
    r   <- s[[k]]
    ttl <- lyr[[k]]

    # Elevation and slope are dominated by the Himalaya, so cap the colour scale
    # at the 98th percentile (for display only) so lowland detail is visible.
    if (k %in% c("elev", "slope")) {
      q   <- quantile(values(r), 0.98, na.rm = TRUE)
      r   <- clamp(r, upper = q, values = TRUE)
      ttl <- paste0(ttl, "\n(colour scale capped at 98th percentile)")
    }

    plot(r, main = ttl, col = hcl.colors(100, "viridis"),
         mar = c(2.5, 2.5, 3.5, 4.5), axes = TRUE)
  }

  # North arrow and scale bar on the last panel (wrapped so an error here
  # does not stop the figure)
  try(north(xy = "topleft"), silent = TRUE)
  try(sbar(1000, xy = "bottomleft", below = "km", cex = 0.7), silent = TRUE)

  dev.off()
}

# ---- 5. Main-text figure (6 key layers) -------------------------------------
main_layers <- c("slope", "ndvi", "bio14", "bio09", "bio06", "elev")
plot_layers(main_layers, file.path(out_dir, "Fig4_clipped_layers_main.png"),
            nrow = 2, ncol = 3, w = 12, h = 8)

# ---- 6. Appendix figure (the other 7 layers) --------------------------------
app_layers <- setdiff(names(lyr), main_layers)
plot_layers(app_layers, file.path(out_dir, "FigA_clipped_layers_appendix.png"),
            nrow = 3, ncol = 3, w = 12, h = 11)

# ---- 7. Optional: all 13 layers in one figure -------------------------------
# plot_layers(names(lyr), file.path(out_dir, "Fig_all_layers.png"),
#             nrow = 4, ncol = 4, w = 14, h = 13)