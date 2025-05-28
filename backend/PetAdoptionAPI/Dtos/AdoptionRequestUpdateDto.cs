// DTO used for updating adoption request data (PUT/PATCH request).
namespace PetAdoptionAPI.Dtos
{
    public class AdoptionRequestUpdateDto
    {
        // The status of the adoption request (e.g., "approved", "rejected").
        public string RequestStatus { get; set; }
        // Response from the shelter or admin.
        public string RequestResponse { get; set; }
        // Date of the response (optional).
        public DateTime? RequestResponseDate { get; set; }
        // Whether the request is verified (optional, for admin).
        public bool? RequestIsVerified { get; set; }
        // Whether the request is completed (optional, for admin).
        public bool? RequestIsCompleted { get; set; }
    }
}
