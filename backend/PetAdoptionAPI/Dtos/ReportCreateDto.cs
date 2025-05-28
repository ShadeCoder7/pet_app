// DTO used to create a new report (POST request).
namespace PetAdoptionAPI.Dtos
{
    public class ReportCreateDto
    {
        // Title of the report.
        public string ReportTitle { get; set; }
        // Type of the report (e.g., lost, found, abuse, other).
        public string ReportType { get; set; }
        // Detailed description of the report.
        public string ReportDescription { get; set; }
        // URL of the image associated with the report (optional).
        public string ReportImageUrl { get; set; }
        // Initial status (default can be "pending" in the backend).
        public string ReportStatus { get; set; }
        // Street address or specific location.
        public string ReportAddress { get; set; }
        // City of the report (optional).
        public string ReportCity { get; set; }
        // Province or state (optional).
        public string ReportProvince { get; set; }
        // Postal or ZIP code (optional).
        public string ReportPostalCode { get; set; }
        // Country of the report (optional).
        public string ReportCountry { get; set; }
        // Latitude for location (optional).
        public decimal? ReportLatitude { get; set; }
        // Longitude for location (optional).
        public decimal? ReportLongitude { get; set; }
        // Animal-specific fields.
        public string AnimalName { get; set; }
        public string AnimalGender { get; set; }
        public string AnimalBreed { get; set; }
        public DateTime? LastSeenDate { get; set; }
        // Foreign keys.
        public Guid? UserId { get; set; }
        public string AnimalTypeKey { get; set; }
        public string AnimalSizeKey { get; set; }
    }
}
