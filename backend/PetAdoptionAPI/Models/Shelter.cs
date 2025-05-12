// Models/Shelter.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("shelters")]
    public class Shelter
    {
        // Private setter for ShelterId to make it immutable outside the class
        [Key]
        public Guid ShelterId { get; private set; }  // Unique ID for the shelter

        [Required]
        [MaxLength(100)]
        public string ShelterName { get; set; }  // Name of the shelter

        [Required]
        public string ShelterAddress { get; set; }  // Address of the shelter

        [Required]
        public string ShelterDescription { get; set; }  // Description of the shelter

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Capacity must be greater than zero.")]
        public int ShelterCapacity { get; set; }  // Capacity of the shelter

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Current capacity cannot be negative.")]
        public int ShelterCurrentCapacity { get; set; }  // Current capacity of the shelter

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Current occupancy cannot be negative.")]
        public int ShelterCurrentOccupancy { get; set; }  // Current occupancy of the shelter

        public string ShelterWebsite { get; set; }  // Optional website for the shelter

        [Required]
        public string ShelterPhoneNumber { get; set; }  // Phone number for the shelter

        public DateTime ShelterCreateDate { get; set; } = DateTime.Now;  // When the shelter was created

        public DateTime ShelterUpdateDate { get; set; } = DateTime.Now;  // When the shelter details were last updated

        public bool ShelterIsVerified { get; set; } = false;  // Whether the shelter is verified

        // Foreign key to the users table (user responsible for the shelter)
        public Guid? UserId { get; set; }

        [ForeignKey("UserId")]
        public User User { get; set; }  // Navigation property to the User model
    }
}
