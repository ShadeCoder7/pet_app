// DTO used to register/create a new user (handled by backend after Firebase Auth).
namespace PetAdoptionAPI.Dtos
{
    public class UserCreateDto
    {
        public string FirebaseUid { get; set; }
        public string UserEmail { get; set; }
        public string UserRole { get; set; }
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public string UserPhoneNumber { get; set; }
        public string UserAddress { get; set; }
        public DateTime UserBirthDate { get; set; }
        public string UserProfilePicture { get; set; }
    }
}
