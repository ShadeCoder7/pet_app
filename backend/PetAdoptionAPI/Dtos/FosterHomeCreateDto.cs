// DTO used to create a new foster home (POST request).
public class FosterHomeCreateDto
{
    // Name of the foster home.
    public string FosterHomeName { get; set; }
    // Description of the foster home.
    public string FosterHomeDescription { get; set; }
    // Maximum number of animals the foster home can host.
    public int FosterHomeCapacity { get; set; }
    // Website URL of the foster home.
    public string FosterHomeWebsite { get; set; }
    // Address of the foster home.
    public string FosterHomeAddress { get; set; }
    // Phone number for contact.
    public string FosterHomePhoneNumber { get; set; }
    // (Optional) UserId for the owner or manager.
    public Guid? UserId { get; set; }
}

