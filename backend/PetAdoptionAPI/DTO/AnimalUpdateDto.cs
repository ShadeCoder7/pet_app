// DTO used for updating animal data (PUT/PATCH request).
public class AnimalUpdateDto
{
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
}
