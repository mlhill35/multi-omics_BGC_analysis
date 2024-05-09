library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

# Assuming final_results_sorted is already in your environment

# Step 1: Separate 'sample' into 'time' and 'sample_type'
final_results_sorted <- final_results_sorted %>%
  mutate(time = sub("_.*", "", sample),
         sample_type = sub(".*_", "", sample))

# Step 2: Create subsets for each ion_type
data_M_H <- final_results_sorted %>% filter(ion_type == "M+H")
data_M_Na <- final_results_sorted %>% filter(ion_type == "M+Na")
data_M_2H <- final_results_sorted %>% filter(ion_type == "M+2H")

# Function to create bar graphs
create_bar_graph <- function(data, ion_type_name) {
  ggplot(data, aes(x = sample_type, y = log(average_peak_area), fill = time)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
    geom_text(aes(label = sprintf("%.3g", average_mass_error), 
                  y = log(average_peak_area) + 0.3), position = position_dodge(width = 0.9), size = 3) +
    labs(title = paste("Ion Type:", ion_type_name),
         x = "Sample Type",
         y = "Log of Peak Area") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
}

# Step 3: Create bar graphs for each ion_type
plot_M_H <- create_bar_graph(data_M_H, "M+H")
plot_M_Na <- create_bar_graph(data_M_Na, "M+Na")
plot_M_2H <- create_bar_graph(data_M_2H, "M+2H")

# Step 4: Use gridExtra to arrange the plots side by side
combined_plot <- grid.arrange(plot_M_H, plot_M_Na, plot_M_2H, ncol = 3)

# Display the combined plot
print(combined_plot)

# Optionally, save the combined plot to a file
ggsave("~/multi-omics_BGC_analysis/plots/combined_ion_types.png", combined_plot, width = 20, height = 8)
