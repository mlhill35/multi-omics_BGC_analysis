library(dplyr)
library(tidyr)

# Define a very small tolerance for exact mass matching
tolerance <- 0.001

# Prepare the ion data, simplifying ion type names
expanded_ions <- calculated_ions %>%
  pivot_longer(cols = -name, names_to = "ion_type", values_to = "expected_mz") %>%
  mutate(ion_type = sub("m/z \\[", "", ion_type),
         ion_type = sub("\\]", "", ion_type))

# Find matching m/z values within the small tolerance and calculate mass error
matches <- mass_spec_data %>%
  pivot_longer(cols = -`row m/z`, names_to = "sample", values_to = "peak_area") %>%
  cross_join(expanded_ions) %>%
  filter(abs(`row m/z` - expected_mz) <= tolerance) %>%
  mutate(mass_error = ((`row m/z` - expected_mz) / expected_mz) * 1e6)

# Adjust sample names to aggregate across replicates
matches <- matches %>%
  mutate(sample = sub("_\\d{2}\\.mzXML Peak area$", "", sample))

# Group by relevant identifiers and compute averages for peak area and mass error
final_results <- matches %>%
  group_by(`row m/z`, name, ion_type, sample) %>%
  summarise(average_peak_area = mean(peak_area, na.rm = TRUE),
            average_mass_error = mean(mass_error, na.rm = TRUE), .groups = "drop") %>%
  filter(average_peak_area > 0, ion_type != "mass")  # Exclude 'mass' entries and zero peak areas

# Here we refine the results to keep only the ion with the lowest mass error for each ion type per sample
final_results_min_error <- final_results %>%
  group_by(sample, name, ion_type) %>%
  filter(average_mass_error == min(average_mass_error)) %>%
  ungroup()  # It's important to ungroup for any further operations that aren't supposed to be grouped

# Sort the final results by 'sample'
final_results_sorted <- final_results_min_error %>%
  arrange(sample)

# At this point you have a filtered metabolomics file with m/z ids
# These can be cross referenced with mirror plots (e.g., observed in GNPS) to ensure that the expected product ions match previous spectra
# However the next set of Rscripts for data analysis assumes they all have the same product ions (indicating that they are the same compounds)
# Simply filter the m/z rows that coincide with the correct fragmentation pattern before preceding for relevance

# Export file as csv
write.csv(final_results_sorted, "~/multi-omics_BGC_analysis/example_usage/mass_spec_data/mass_spec_MINED.csv")

