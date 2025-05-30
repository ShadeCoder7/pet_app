using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("animals")]
    public class Animal
    {
        [Key]
        [Column("animal_id")]
        public Guid AnimalId { get; set; }  // Unique ID for the animal

        [Required]
        [Column("animal_name")]
        [StringLength(75)]
        public string AnimalName { get; set; }  // Name of the animal

        [Column("animal_age")]
        public int? AnimalAge { get; set; }  // Age in years (optional)

        [Required]
        [Column("animal_gender")]
        [StringLength(20)]
        [RegularExpression("^(male|female|not_specified)$", ErrorMessage = "Animal gender must be 'male', 'female', or 'not_specified'.")]
        public string AnimalGender { get; set; }  // Gender with constraint

        [Required]
        [Column("animal_breed")]
        [StringLength(75)]
        public string AnimalBreed { get; set; }  // Breed (required per schema)

        [Required]
        [Column("animal_description")]
        public string AnimalDescription { get; set; }  // Detailed description

        [Required]
        [Column("animal_status")]
        [StringLength(25)]
        [RegularExpression("^(not_available|available|adopted|fostered|in_shelter)$", ErrorMessage = "Invalid animal status.")]
        public string AnimalStatus { get; set; }  // Adoption status

        [Column("ad_posted_date")]
        public DateTime AdPostedDate { get; set; } = DateTime.UtcNow;  // When posted

        [Column("ad_update_date")]
        public DateTime AdUpdateDate { get; set; } = DateTime.UtcNow;  // Last updated

        [Required]
        [Column("animal_location")]
        public string AnimalLocation { get; set; }  // Location description

        [Column("animal_latitude", TypeName = "decimal(9,6)")]
        public decimal? AnimalLatitude { get; set; }  // Latitude (optional)

        [Column("animal_longitude", TypeName = "decimal(9,6)")]
        public decimal? AnimalLongitude { get; set; }  // Longitude (optional)

        [Column("animal_is_verified")]
        public bool AnimalIsVerified { get; set; } = false;  // Verified flag

        [Column("user_id")]
        public Guid? UserId { get; set; }  // FK user who posted or responsible (nullable)

        [Column("shelter_id")]
        public Guid? ShelterId { get; set; }  // FK shelter (nullable)

        [Column("foster_home_id")]
        public Guid? FosterHomeId { get; set; }  // FK foster home (nullable)

        [Column("animal_type_key")]
        public string AnimalTypeKey { get; set; }  // FK animal type (nullable per DB? If not, add [Required])

        [Required]
        [Column("animal_size_key")]
        public string AnimalSizeKey { get; set; }  // FK animal size

        // Navigation properties
        [ForeignKey("UserId")]
        public User? User { get; set; }

        [ForeignKey("ShelterId")]
        public Shelter? Shelter { get; set; }

        [ForeignKey("FosterHomeId")]
        public FosterHome? FosterHome { get; set; }

        [ForeignKey("AnimalTypeKey")]
        public AnimalType? AnimalType { get; set; }

        [ForeignKey("AnimalSizeKey")]
        public AnimalSize AnimalSize { get; set; }
    }
}
