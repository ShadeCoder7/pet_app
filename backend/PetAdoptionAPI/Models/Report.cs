using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("reports")]
    public class Report
    {
        [Key]
        [Column("report_id")]
        public Guid ReportId { get; set; }  // Unique ID for the report

        [Required]
        [Column("report_title")]
        [StringLength(100)]
        public string ReportTitle { get; set; }  // Title of the report

        [Required]
        [Column("report_type")]
        [StringLength(30)]
        [RegularExpression("^(lost|found|abuse|other)$", ErrorMessage = "Invalid report type.")]
        public string ReportType { get; set; }  // Type of the report

        [Required]
        [Column("report_description")]
        public string ReportDescription { get; set; }  // Detailed description

        [Column("report_date")]
        public DateTime ReportDate { get; set; } = DateTime.UtcNow;  // Creation date

        [Column("report_update_date")]
        public DateTime ReportUpdateDate { get; set; } = DateTime.UtcNow;  // Last update date

        [Column("report_image_url")]
        public string? ReportImageUrl { get; set; }  // Image URL (optional)

        [Required]
        [Column("report_status")]
        [StringLength(20)]
        [RegularExpression("^(pending|in_progress|resolved|closed)$", ErrorMessage = "Invalid report status.")]
        public string ReportStatus { get; set; } = "pending";  // Status of the report

        [Column("report_address")]
        public string? ReportAddress { get; set; }  // Address (optional)

        [Column("report_city")]
        [StringLength(100)]
        public string? ReportCity { get; set; }  // City (optional)

        [Column("report_province")]
        [StringLength(100)]
        public string? ReportProvince { get; set; }  // Province or state (optional)

        [Column("report_postal_code")]
        [StringLength(15)]
        public string? ReportPostalCode { get; set; }  // Postal or ZIP code (optional)

        [Column("report_country")]
        [StringLength(100)]
        public string? ReportCountry { get; set; }  // Country (optional)

        [Column("report_latitude", TypeName = "decimal(9,6)")]
        public decimal? ReportLatitude { get; set; }  // Latitude (optional)

        [Column("report_longitude", TypeName = "decimal(9,6)")]
        public decimal? ReportLongitude { get; set; }  // Longitude (optional)

        [Column("report_is_verified")]
        public bool ReportIsVerified { get; set; } = false;  // Verified flag

        [Column("animal_name")]
        [StringLength(75)]
        public string? AnimalName { get; set; }  // Animal name (optional)

        [Column("animal_gender")]
        [StringLength(20)]
        [RegularExpression("^(male|female|unknown)$", ErrorMessage = "Invalid animal gender.")]
        public string? AnimalGender { get; set; }  // Gender of animal (optional)

        [Column("animal_breed")]
        [StringLength(75)]
        public string? AnimalBreed { get; set; }  // Breed of animal (optional)

        [Column("last_seen_date")]
        public DateTime? LastSeenDate { get; set; }  // When last seen (optional)

        [Column("user_id")]
        public Guid? UserId { get; set; }  // FK to user (nullable)

        [Column("animal_type_key")]
        public string? AnimalTypeKey { get; set; }  // FK to animal type (nullable)

        [Column("animal_size_key")]
        public string? AnimalSizeKey { get; set; }  // FK to animal size (nullable)

        // Navigation properties

        [ForeignKey("UserId")]
        public User? User { get; set; }

        [ForeignKey("AnimalTypeKey")]
        public AnimalType? AnimalType { get; set; }

        [ForeignKey("AnimalSizeKey")]
        public AnimalSize? AnimalSize { get; set; }
    }
}
