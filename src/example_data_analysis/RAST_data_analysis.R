library(dplyr)
library(ggplot2)

# Load the data by downloading the genome directory from the RAST server page for your subject genome, saving it as an xlsx file, and importing into rstudioworkbench
data <- Genome_Directory

# Goal 1: Identify the top 10 most common peg and rna functions (peg: protein encoding gene, rna: ribonucleic acid)

# Check if the dataset is correctly recognized as expected
print(head(data))
print(colnames(data))

# Filter and count the top 10 functions for 'peg', excluding 'hypothetical protein'
peg_data <- data %>%
  filter(type == "peg" & `function` != "hypothetical protein") %>%
  group_by(`function`) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count)) %>%
  slice_max(order_by = count, n = 10)

# Filter and count the top 10 functions for 'rna'
rna_data <- data %>%
  filter(type == "rna") %>%
  group_by(`function`) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count)) %>%
  slice_max(order_by = count, n = 10)

# Plotting for PEG functions, now excluding 'hypothetical protein'
peg_plot <- ggplot(peg_data, aes(x = reorder(`function`, count), y = count)) +
  geom_bar(stat = "identity", width = 0.5) +
  coord_flip() +
  labs(title = "Top 10 Most Common PEG Functions", x = "Function", y = "Count") +
  theme(axis.text.y = element_text(size = 11, angle = 20))

# Plotting for RNA functions
rna_plot <- ggplot(rna_data, aes(x = reorder(`function`, count), y = count)) +
  geom_bar(stat = "identity", width = 0.5) +
  coord_flip() +
  labs(title = "Top 10 Most Common RNA Functions", x = "Function", y = "Count")

# Print the plots to see the output
print(peg_plot)
print(rna_plot)

# Goal 2: Observe the distribution and abundance of hypothetical proteins (unnanotated) across the subject genome

# Filter for hypothetical proteins
hypothetical_data <- data %>%
  filter(grepl("hypothetical", `function`)) %>%
  mutate(contig_index = as.factor(match(contig_id, unique(contig_id))))

# Summarize data by contig
contig_summary <- hypothetical_data %>%
  group_by(contig_id) %>%
  summarise(total_protein_length = sum(stop - start), .groups = 'drop')

plot <- ggplot(contig_summary, aes(x = contig_id, y = total_protein_length, fill = total_protein_length)) +
  geom_col() +
  coord_flip() +  # Flipping coordinates to put contig_id on the y-axis
  scale_fill_gradient(low = "blue", high = "red") +  # Gradient fill based on total_protein_length
  labs(title = "Total Hypothetical Protein Length by Contig",
       x = "Total Protein Length",
       y = "Contig") +  # Corrected axis labels as coord_flip swaps the axes
  theme_minimal() +  # Apply minimal theme
  theme(axis.text.y = element_text(size = 5, angle = 35))  # Adjust font size and angle of y-axis labels

# Display the plot
print(plot)
