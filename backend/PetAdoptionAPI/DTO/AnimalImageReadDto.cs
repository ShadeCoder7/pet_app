// DTO used for reading/displaying animal image data (GET request).
public class AnimalImageReadDto
{
    public int AnimalImageId { get; set; }
    public string ImageUrl { get; set; }
    public DateTime UploadDate { get; set; }
    public string ImageAlternativeText { get; set; }
    public string ImageDescription { get; set; }
    public bool IsMainImage { get; set; }
    public bool ImageIsVerified { get; set; }
    public Guid AnimalId { get; set; }
}
