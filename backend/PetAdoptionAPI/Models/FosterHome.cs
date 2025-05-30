using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("foster_homes")]
    public class FosterHome
    {
        [Key]
        [Column("foster_home_id")]
        public Guid FosterHomeId { get; set; }  // Unique ID for the foster home

        [Required]
        [Column("foster_home_name")]
        [StringLength(100)]
        public string FosterHomeName { get; set; }  // Name of the foster home

        [Required]
        [Column("foster_home_description")]
        public string FosterHomeDescription { get; set; }  // Description of the foster home

        [Required]
        [Column("foster_home_capacity")]
        [Range(1, int.MaxValue, ErrorMessage = "Capacity must be greater than zero.")]
        public int FosterHomeCapacity { get; set; }  // Capacity of the foster home

        [Required]
        [Column("foster_home_current_capacity")]
        [Range(0, int.MaxValue, ErrorMessage = "Current capacity cannot be negative.")]
        public int FosterHomeCurrentCapacity { get; set; }  // Current capacity of the foster home

        [Required]
        [Column("foster_home_current_occupancy")]
        [Range(0, int.MaxValue, ErrorMessage = "Current occupancy cannot be negative.")]
        public int FosterHomeCurrentOccupancy { get; set; }  // Current occupancy of the foster home

        [Column("foster_home_website")]
        public string? FosterHomeWebsite { get; set; }  // Optional website for the foster home

        [Required]
        [Column("foster_home_address")]
        public string FosterHomeAddress { get; set; }  // Address of the foster home

        [Required]
        [Column("foster_home_phone_number")]
        [StringLength(20)]
        public string FosterHomePhoneNumber { get; set; }  // Phone number for the foster home

        [Column("foster_home_create_date")]
        public DateTime FosterHomeCreateDate { get; set; } = DateTime.UtcNow;  // Creation date

        [Column("foster_home_update_date")]
        public DateTime FosterHomeUpdateDate { get; set; } = DateTime.UtcNow;  // Last update date

        [Column("foster_home_is_verified")]
        public bool FosterHomeIsVerified { get; set; } = false;  // Whether the foster home is verified

        [Column("user_id")]
        public Guid? UserId { get; set; }  // Foreign key (user responsible for the foster home)

        [ForeignKey("UserId")]
        public User? User { get; set; }  // Navigation property (nullable)
    }
}
