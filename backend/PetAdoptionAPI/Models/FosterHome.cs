// Models/FosterHome.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("foster_homes")]
    public class FosterHome
    {
        [Key]
        public Guid FosterHomeId { get; private set; }  // Unique ID for the foster home

        [Required]
        [MaxLength(100)]
        public string FosterHomeName { get; set; }  // Name of the foster home

        [Required]
        public string FosterHomeDescription { get; set; }  // Description of the foster home

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Capacity must be greater than zero.")]
        public int FosterHomeCapacity { get; set; }  // Capacity of the foster home

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Current capacity cannot be negative.")]
        public int FosterHomeCurrentCapacity { get; set; }  // Current capacity of the foster home

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Current occupancy cannot be negative.")]
        public int FosterHomeCurrentOccupancy { get; set; }  // Current occupancy of the foster home

        public string FosterHomeWebsite { get; set; }  // Optional website for the foster home

        [Required]
        public string FosterHomeAddress { get; set; }  // Address of the foster home

        [Required]
        public string FosterHomePhoneNumber { get; set; }  // Phone number for the foster home

        public DateTime FosterHomeCreateDate { get; set; } = DateTime.Now;  // When the foster home was created

        public DateTime FosterHomeUpdateDate { get; set; } = DateTime.Now;  // When the foster home details were last updated

        public bool FosterHomeIsVerified { get; set; } = false;  // Whether the foster home is verified

        // Foreign key to the users table (user responsible for the foster home)
        public Guid? UserId { get; set; }

        [ForeignKey("UserId")]
        public User User { get; set; }  // Navigation property to the User model
    }
}
