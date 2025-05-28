// DTO used for updating foster home data (PUT/PATCH request).
public class FosterHomeUpdateDto
{
    public string FosterHomeName { get; set; }
    public string FosterHomeDescription { get; set; }
    public int? FosterHomeCapacity { get; set; }
    public string FosterHomeWebsite { get; set; }
    public string FosterHomeAddress { get; set; }
    public string FosterHomePhoneNumber { get; set; }
    public Guid? UserId { get; set; }
    // Allow updating verification status by admin if needed.
    public bool? FosterHomeIsVerified { get; set; }
}
