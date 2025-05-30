// DTO used for partial updates (PATCH requests) on user data.
namespace PetAdoptionAPI.Dtos
{
    public class UserPatchDto
    {
        // Allows updating the user's first name (optional).
        public string? UserFirstName { get; set; }
        
        // Allows updating the user's last name (optional).
        public string? UserLastName { get; set; }
        
        // Allows updating the user's phone number (optional).
        public string? UserPhoneNumber { get; set; }
        
        // Allows updating the user's address (optional).
        public string? UserAddress { get; set; }
        
        // Allows updating the user's birth date (optional).
        public DateTime? UserBirthDate { get; set; }
        
        // Allows updating the user's profile picture (optional).
        public string? UserProfilePicture { get; set; }
        
        // Allows updating the user role (optional, for admin actions).
        public string? UserRole { get; set; }
        
        // Allows updating the role verification status (optional, for admin actions).
        public bool? IsRoleVerified { get; set; }
        
        // Allows updating the general user verification status (optional, for admin actions).
        public bool? UserIsVerified { get; set; }
    }
}
