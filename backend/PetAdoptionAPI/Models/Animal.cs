// Models/Animal.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("animals")]
    public class Animal
    {
        // Private setter for AnimalId to make it immutable outside the class
        [Key]
        public Guid AnimalId { get; private set; }  // Unique ID for the animal

        [Required]
        [MaxLength(75)]
        public string AnimalName { get; set; }  // Name of the animal

        public int? AnimalAge { get; set; }  // Age (in years), optional

        [Required]
        [MaxLength(20)]
        [RegularExpression("^(male|female|not_specified)$", ErrorMessage = "Gender must be 'male', 'female', or 'not_specified'.")]
        public string AnimalGender { get; set; }  // Gender (male, female, or not_specified)

        [Required]
        [MaxLength(75)]
        public string AnimalBreed { get; set; }  // Breed of the animal

        [Required]
        public string AnimalDescription { get; set; }  // Detailed description

        [Required]
        [RegularExpression("^(not_available|available|adopted|fostered|in_shelter)$", ErrorMessage = "Status must be one of the following: 'not_available', 'available', 'adopted', 'fostered', 'in_shelter'.")]
        public string AnimalStatus { get; set; }  // Adoption status

        public DateTime AdPostedDate { get; set; } = DateTime.Now;  // When the animal was posted

        public DateTime AdUpdateDate { get; set; } = DateTime.Now;  // When the animal was last updated

        [Required]
        public string AnimalLocation { get; set; }  // Textual address or location description

        public decimal? AnimalLatitude { get; set; }  // Latitude (for geolocation)

        public decimal? AnimalLongitude { get; set; }  // Longitude (for geolocation)

        public bool AnimalIsVerified { get; set; } = false;  // Whether the animal is verified

        // Foreign keys
        public Guid? UserId { get; set; }  // Foreign key to the user who posted or is responsible for the animal
        public Guid? ShelterId { get; set; }  // Foreign key to the shelter, optional
        public Guid? FosterHomeId { get; set; }  // Foreign key to the foster home, optional
        public string AnimalTypeKey { get; set; }  // Foreign key to animal type (dog, cat, etc.)
        public string AnimalSizeKey { get; set; }  // Foreign key to animal size (small, medium, large)

        // Navigation properties (for easier access to related data)
        [ForeignKey("UserId")]
        public User User { get; set; }

        [ForeignKey("ShelterId")]
        public Shelter Shelter { get; set; }

        [ForeignKey("FosterHomeId")]
        public FosterHome FosterHome { get; set; }

        [ForeignKey("AnimalTypeKey")]
        public AnimalType AnimalType { get; set; }

        [ForeignKey("AnimalSizeKey")]
        public AnimalSize AnimalSize { get; set; }
    }
}
