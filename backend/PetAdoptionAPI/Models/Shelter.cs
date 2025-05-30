using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("shelters")]
    public class Shelter
    {
        [Key]
        [Column("shelter_id")]
        public Guid ShelterId { get; set; }  // Unique ID, auto-generated in the DB

        [Required]
        [Column("shelter_name")]
        [StringLength(100)]
        public string ShelterName { get; set; }  // Name of the shelter

        [Required]
        [Column("shelter_address")]
        public string ShelterAddress { get; set; }  // Address of the shelter

        [Required]
        [Column("shelter_description")]
        public string ShelterDescription { get; set; }  // Description of the shelter

        [Required]
        [Column("shelter_capacity")]
        [Range(1, int.MaxValue, ErrorMessage = "Capacity must be greater than zero.")]
        public int ShelterCapacity { get; set; }  // Capacity (must be greater than 0)

        [Required]
        [Column("shelter_current_capacity")]
        [Range(0, int.MaxValue, ErrorMessage = "Current capacity cannot be negative.")]
        public int ShelterCurrentCapacity { get; set; }  // Current capacity (>= 0)

        [Required]
        [Column("shelter_current_occupancy")]
        [Range(0, int.MaxValue, ErrorMessage = "Current occupancy cannot be negative.")]
        public int ShelterCurrentOccupancy { get; set; }  // Current occupancy (>= 0)

        [Column("shelter_website")]
        public string? ShelterWebsite { get; set; }  // Optional website

        [Required]
        [Column("shelter_phone_number")]
        [StringLength(20)]
        public string ShelterPhoneNumber { get; set; }  // Phone number (required)

        [Column("shelter_create_date")]
        public DateTime ShelterCreateDate { get; set; } = DateTime.UtcNow;  // Creation date

        [Column("shelter_update_date")]
        public DateTime ShelterUpdateDate { get; set; } = DateTime.UtcNow;  // Last update date

        [Column("shelter_is_verified")]
        public bool ShelterIsVerified { get; set; } = false;  // Whether the shelter is verified

        [Column("user_id")]
        public Guid? UserId { get; set; }  // Foreign key (nullable)

        [ForeignKey("UserId")]
        public User? User { get; set; }  // Navigation property (nullable)
    }
}
