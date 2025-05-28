// DTO used for reading/displaying animal type data (GET request).
public class AnimalTypeReadDto
{
    // Key that identifies the animal type (e.g., "dog", "cat").
    public string AnimalTypeKey { get; set; }
    // Display label for the animal type (e.g., "Dog", "Cat").
    public string AnimalTypeLabel { get; set; }
}
