// DTO used for reading/displaying report data (GET request).
namespace PetAdoptionAPI.Dtos
{
    public class ReportReadDto
    {
        public Guid ReportId { get; set; }
        public string ReportTitle { get; set; }
        public string ReportType { get; set; }
        public string ReportDescription { get; set; }
        public DateTime ReportDate { get; set; }
        public DateTime ReportUpdateDate { get; set; }
        public string ReportImageUrl { get; set; }
        public string ReportStatus { get; set; }
        public string ReportAddress { get; set; }
        public string ReportCity { get; set; }
        public string ReportProvince { get; set; }
        public string ReportPostalCode { get; set; }
        public string ReportCountry { get; set; }
        public decimal? ReportLatitude { get; set; }
        public decimal? ReportLongitude { get; set; }
        public bool ReportIsVerified { get; set; }
        public string AnimalName { get; set; }
        public string AnimalGender { get; set; }
        public string AnimalBreed { get; set; }
        public DateTime? LastSeenDate { get; set; }
        public Guid? UserId { get; set; }
        public string AnimalTypeKey { get; set; }
        public string AnimalSizeKey { get; set; }
    }
}
