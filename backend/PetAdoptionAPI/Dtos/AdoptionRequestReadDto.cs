// DTO used for reading/displaying adoption request data (GET request).
public class AdoptionRequestReadDto
{
    public Guid AdoptionRequestId { get; set; }
    public DateTime RequestDate { get; set; }
    public DateTime RequestUpdateDate { get; set; }
    public string RequestStatus { get; set; }
    public string RequestMessage { get; set; }
    public string RequestResponse { get; set; }
    public DateTime? RequestResponseDate { get; set; }
    public bool RequestIsVerified { get; set; }
    public bool RequestIsCompleted { get; set; }
    public Guid UserId { get; set; }
    public Guid AnimalId { get; set; }
}
