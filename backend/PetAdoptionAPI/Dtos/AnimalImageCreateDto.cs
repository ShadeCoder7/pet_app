// DTO used to create a new animal image (POST request).
namespace PetAdoptionAPI.Dtos
{
    public class AnimalImageCreateDto
    {
        // URL of the image to be uploaded.
        public string ImageUrl { get; set; }
        // Alternative text for the image (accessibility).
        public string ImageAlternativeText { get; set; }
        // Description of the image.
        public string ImageDescription { get; set; }
        // Whether this is the main image for the animal (optional).
        public bool? IsMainImage { get; set; }
        // Foreign key to the associated animal.
        public Guid AnimalId { get; set; }
    }
}
