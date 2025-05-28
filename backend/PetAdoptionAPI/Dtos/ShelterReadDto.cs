// DTO used for reading/displaying shelter data (GET request).
namespace PetAdoptionAPI.Dtos
{
    public class ShelterReadDto
    {
        public Guid ShelterId { get; set; }
        public string ShelterName { get; set; }
        public string ShelterAddress { get; set; }
        public string ShelterDescription { get; set; }
        public int ShelterCapacity { get; set; }
        public int ShelterCurrentCapacity { get; set; }
        public int ShelterCurrentOccupancy { get; set; }
        public string ShelterWebsite { get; set; }
        public string ShelterPhoneNumber { get; set; }
        public DateTime ShelterCreateDate { get; set; }
        public DateTime ShelterUpdateDate { get; set; }
        public bool ShelterIsVerified { get; set; }
        public Guid? UserId { get; set; }
    }
}
