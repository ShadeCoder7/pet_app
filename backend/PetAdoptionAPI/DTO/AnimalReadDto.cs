// DTO used when reading or displaying animal data (GET request).
public class AnimalReadDto
{
    // Unique identifier for the animal.
    public Guid AnimalId { get; set; }
    public string AnimalName { get; set; }
    public int? AnimalAge { get; set; }
    public string AnimalGender { get; set; }
    public string AnimalBreed { get; set; }
    public string AnimalDescription { get; set; }
    public string AnimalStatus { get; set; }
    public string AnimalLocation { get; set; }
    public double? AnimalLatitude { get; set; }
    public double? AnimalLongitude { get; set; }
    public string AnimalTypeKey { get; set; }
    public string AnimalSizeKey { get; set; }
    public Guid? UserId { get; set; }
    public Guid? ShelterId { get; set; }
    public Guid? FosterHomeId { get; set; }
    // Indicates if the animal has been verified (e.g., by an admin).
    public bool AnimalIsVerified { get; set; }
    // Date when the ad or entry was posted.
    public DateTime AdPostedDate { get; set; }
    // Date when the entry was last updated.
    public DateTime AdUpdateDate { get; set; }
    // List of associated images (using DTO for images).
    public List<AnimalImageReadDto> Images { get; set; }
}
