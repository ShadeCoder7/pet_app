// DTO used to create a new shelter (POST request).
namespace PetAdoptionAPI.Dtos
{
    public class ShelterCreateDto
    {
        // Name of the shelter.
        public string ShelterName { get; set; }
        // Address of the shelter.
        public string ShelterAddress { get; set; }
        // Description of the shelter.
        public string ShelterDescription { get; set; }
        // Maximum capacity of the shelter.
        public int ShelterCapacity { get; set; }
        // Website URL of the shelter (optional).
        public string ShelterWebsite { get; set; }
        // Phone number for the shelter.
        public string ShelterPhoneNumber { get; set; }
        // (Optional) UserId for the manager or responsible user.
        public Guid? UserId { get; set; }
    }
}
