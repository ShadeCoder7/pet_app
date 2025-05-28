// DTO used for reading/displaying foster home data (GET request).
public class FosterHomeReadDto
{
    public Guid FosterHomeId { get; set; }
    public string FosterHomeName { get; set; }
    public string FosterHomeDescription { get; set; }
    public int FosterHomeCapacity { get; set; }
    public int FosterHomeCurrentCapacity { get; set; }
    public int FosterHomeCurrentOccupancy { get; set; }
    public string FosterHomeWebsite { get; set; }
    public string FosterHomeAddress { get; set; }
    public string FosterHomePhoneNumber { get; set; }
    public DateTime FosterHomeCreateDate { get; set; }
    public DateTime FosterHomeUpdateDate { get; set; }
    public bool FosterHomeIsVerified { get; set; }
    public Guid? UserId { get; set; }
}
