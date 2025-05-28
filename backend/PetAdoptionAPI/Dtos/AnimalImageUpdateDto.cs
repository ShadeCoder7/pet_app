// DTO used for updating animal image data (PUT/PATCH request).
namespace PetAdoptionAPI.Dtos
{
    public class AnimalImageUpdateDto
    {
        public string ImageUrl { get; set; }
        public string ImageAlternativeText { get; set; }
        public string ImageDescription { get; set; }
        public bool? IsMainImage { get; set; }
        // Allow admin to update verification status if needed.
        public bool? ImageIsVerified { get; set; }
    }
}
