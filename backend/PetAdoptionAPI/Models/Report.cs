// Models/Report.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("reports")]
    public class Report
    {
        // Private setter for ReportId to make it immutable outside the class
        [Key]
        public Guid ReportId { get; private set; }  // Unique ID for the report

        [Required]
        [MaxLength(100)]
        public string ReportTitle { get; set; }  // Title of the report

        [Required]
        [MaxLength(30)]
        [RegularExpression("^(lost|found|abuse|other)$", ErrorMessage = "Report type must be one of the following: 'lost', 'found', 'abuse', 'other'.")]
        public string ReportType { get; set; }  // Type of the report (lost, found, abuse, other)

        [Required]
        public string ReportDescription { get; set; }  // Detailed description of the report

        public DateTime ReportDate { get; set; } = DateTime.Now;  // Date when the report was created

        public DateTime ReportUpdateDate { get; set; } = DateTime.Now;  // Date when the report was last updated

        public string ReportImageUrl { get; set; }  // URL of the image associated with the report

        [Required]
        [MaxLength(20)]
        [RegularExpression("^(pending|in_progress|resolved|closed)$", ErrorMessage = "Report status must be one of the following: 'pending', 'in_progress', 'resolved', 'closed'.")]
        public string ReportStatus { get; set; } = "pending";  // Status of the report

        public string ReportAddress { get; set; }  // Street address or specific location

        [MaxLength(100)]
        public string ReportCity { get; set; }  // City of the report

        [MaxLength(100)]
        public string ReportProvince { get; set; }  // Province or state

        [MaxLength(15)]
        public string ReportPostalCode { get; set; }  // Postal or ZIP code

        [MaxLength(100)]
        public string ReportCountry { get; set; }  // Country of the report

        public decimal? ReportLatitude { get; set; }  // Latitude for location

        public decimal? ReportLongitude { get; set; }  // Longitude for location

        public bool ReportIsVerified { get; set; } = false;  // Whether the report is verified

        // Animal-specific information for the report
        [MaxLength(75)]
        public string AnimalName { get; set; }  // Animal name

        [MaxLength(20)]
        [RegularExpression("^(male|female|unknown)$", ErrorMessage = "Animal gender must be 'male', 'female', or 'unknown'.")]
        public string AnimalGender { get; set; }  // Gender of the animal

        [MaxLength(75)]
        public string AnimalBreed { get; set; }  // Breed of the animal

        public DateTime? LastSeenDate { get; set; }  // When the animal was last seen

        // Foreign keys
        public Guid? UserId { get; set; }  // Foreign key to the user who created the report
        public string AnimalTypeKey { get; set; }  // Foreign key to animal type (dog, cat, etc.)
        public string AnimalSizeKey { get; set; }  // Foreign key to animal size (small, medium, large)

        // Navigation properties (for easier access to related data)
        [ForeignKey("UserId")]
        public User User { get; set; }

        [ForeignKey("AnimalTypeKey")]
        public AnimalType AnimalType { get; set; }

        [ForeignKey("AnimalSizeKey")]
        public AnimalSize AnimalSize { get; set; }
    }
}
