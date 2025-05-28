// DTO used for displaying user profile or fetching user data (GET request).
namespace PetAdoptionAPI.Dtos
{
    public class UserReadDto
    {
        public Guid UserId { get; set; }
        public string UserEmail { get; set; }
        public string UserRole { get; set; }
        public bool IsRoleVerified { get; set; }
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public string UserPhoneNumber { get; set; }
        public string UserAddress { get; set; }
        public DateTime CreateUserDate { get; set; }
        public DateTime UserBirthDate { get; set; }
        public string UserProfilePicture { get; set; }
        public bool UserIsVerified { get; set; }
    }
}
