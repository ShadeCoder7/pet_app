// DTO used for reading/displaying animal size data (GET request).
public class AnimalSizeReadDto
{
    // Key that identifies the animal size category (e.g., "small", "medium", "large").
    public string AnimalSizeKey { get; set; }
    // Display label for the animal size (e.g., "Small", "Medium").
    public string AnimalSizeLabel { get; set; }
    // Description for the size (e.g., "Up to 10 kg", "10 to 25 kg").
    public string AnimalSizeDescription { get; set; }
}
