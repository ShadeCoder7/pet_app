// DTO used to create a new adoption request (POST request).
public class AdoptionRequestCreateDto
{
    // Message from the user explaining the adoption request.
    public string RequestMessage { get; set; }
    // (Optional) UserId of the user making the request.
    public Guid UserId { get; set; }
    // AnimalId of the animal being requested for adoption.
    public Guid AnimalId { get; set; }
}
