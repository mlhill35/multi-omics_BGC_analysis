# Load the ggplot2 and dplyr libraries
library(ggplot2)
library(dplyr)

# Verify column names
print(colnames(blast_data))

# Calculate Query Coverage
data <- blast_data %>%
  mutate(Query_Coverage = (align_len / (query_stop - query_start + 1)) * 100)

# Bar plot showing percent identical matches for each query sequence with Query_Coverage as text labels
ggplot(data, aes(x = query_seq_ID, y = percent_identical_matches, fill = subject_seq_ID)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.4) +
  geom_text(aes(label = sprintf("%.2f", Query_Coverage)),   # Format the text to 3 significant figures
            position = position_dodge(width = 0.3), vjust = -0.5, color = "black", size = 3) +
  scale_y_continuous(limits = c(0, 100), expand = expansion(mult = c(0, 0.05))) +
  theme_minimal() +
  labs(title = "Percent Similarity with Subject Sequence",
       x = "Query Sequence ID",
       y = "Percent Similarity (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



