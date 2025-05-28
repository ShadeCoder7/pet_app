// DTO used for updating user data (PUT/PATCH request).
namespace PetAdoptionAPI.Dtos
{
    public class UserUpdateDto
    {
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public string UserPhoneNumber { get; set; }
        public string UserAddress { get; set; }
        public DateTime UserBirthDate { get; set; }
        public string UserProfilePicture { get; set; }
        // Allows updating the user role (for admin actions).
        public string UserRole { get; set; }
        // If you want to allow the admin to update verification status:
        public bool? IsRoleVerified { get; set; }
        public bool? UserIsVerified { get; set; }
    }
}
