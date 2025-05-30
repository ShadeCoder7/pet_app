// Models/User.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("users")]
    public class User
    {
        [Key]
        [Column("user_id")]
        public Guid UserId { get; set; }

        [Required]
        [Column("user_email")]
        [StringLength(100)]
        [EmailAddress] // Ensures the email is in a valid format
        [RegularExpression(@"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", ErrorMessage = "Invalid email format")]
        public string UserEmail { get; set; }

        [Required]
        [Column("user_role")]
        [StringLength(20)] // Limit the length of the role string
        [RegularExpression("^(standard|foster_home|shelter|admin)$", ErrorMessage = "Invalid role")] // Validates that the role is one of the predefined values
        public string UserRole { get; set; }

        [Column("is_role_verified")]
        public bool IsRoleVerified { get; set; } = false;

        [Required]
        [Column("user_first_name")]
        [StringLength(100)]
        public string UserFirstName { get; set; }

        [Required]
        [Column("user_last_name")]
        [StringLength(100)]
        public string UserLastName { get; set; }

        [Required]
        [Column("user_phone_number")]
        [StringLength(20)]
        public string UserPhoneNumber { get; set; }

        [Column("user_address")]
        public string? UserAddress { get; set; }

        [Column("create_user_date")]
        public DateTime CreateUserDate { get; set; } = DateTime.UtcNow; // Default to current UTC time

        [Required]
        [Column("user_birth_date")]
        public DateTime UserBirthDate { get; set; }

        [Column("user_profile_picture")]
        public string? UserProfilePicture { get; set; }

        [Column("user_is_verified")]
        public bool UserIsVerified { get; set; } = false;
    }
}
