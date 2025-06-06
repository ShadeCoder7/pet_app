// DTO used for updating shelter data (PUT/PATCH request).
namespace PetAdoptionAPI.Dtos
{
    public class ShelterUpdateDto
    {
        public string ShelterName { get; set; }
        public string ShelterAddress { get; set; }
        public string ShelterDescription { get; set; }
        public int? ShelterCapacity { get; set; }
        public string ShelterWebsite { get; set; }
        public string ShelterPhoneNumber { get; set; }
        public Guid? UserId { get; set; }
        // Allow admin to update verification status if needed.
        public bool? ShelterIsVerified { get; set; }
    }
}
