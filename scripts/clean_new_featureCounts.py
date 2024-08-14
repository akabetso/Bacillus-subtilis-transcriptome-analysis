#the file was corrupted so we used python to extraxt text file and resaved as csv corecting what ever errors.
import csv
import pandas as pd

with open("../data/reference/featureCounts.csv", "r", encoding="utf-8") as file:
    csv_text = file.read()

# Save the text to a new text file
with open("../data/reference/featureCounts_text.txt", "w", encoding="utf-8") as file:
    file.write(csv_text)


def convert_txt_to_csv(input_file, output_file, delimiter):
  with open(input_file, 'r') as infile, open(output_file, 'w', newline='') as outfile:
    csv_writer = csv.writer(outfile, delimiter=delimiter)
    for line in infile:
      csv_writer.writerow(line.strip().split(delimiter))

# Replace 'input.txt', 'output.csv', and ',' with your actual file paths and delimiter
convert_txt_to_csv("../data/reference/featureCounts_text.txt", "../data/reference/fcount.csv", ",")


# Load the cleaned data
data = pd.read_csv("fcount.csv", encoding="utf-8")

# Define the columns to keep
columns_to_keep = ['Geneid'] + [col for col in data.columns if col.startswith('MM')]

# Create a new DataFrame with only the selected columns
filtered_data = data[columns_to_keep]

# Save the filtered data to a new CSV file
filtered_data.to_csv("fcount_filtered.csv", index=False, encoding="utf-8")
