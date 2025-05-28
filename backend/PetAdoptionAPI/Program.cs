using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;
using PetAdoptionAPI.Interfaces;
using PetAdoptionAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Register ApplicationDbContext for PostgreSQL connection
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

// Register services for dependency injection
builder.Services.AddScoped<IAnimalService, AnimalService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IShelterService, ShelterService>();
builder.Services.AddScoped<IFosterHomeService, FosterHomeService>();
builder.Services.AddScoped<IReportService, ReportService>();
builder.Services.AddScoped<IAnimalTypeService, AnimalTypeService>();
builder.Services.AddScoped<IAnimalSizeService, AnimalSizeService>();
builder.Services.AddScoped<IAnimalImageService, AnimalImageService>();
builder.Services.AddScoped<IAdoptionRequestService, AdoptionRequestService>();

// Register controllers for the REST API
builder.Services.AddControllers();

var app = builder.Build();

// Enable HTTPS redirection (recommended for production)
app.UseHttpsRedirection();

// Authorization middleware (required when you implement authentication/roles)
app.UseAuthorization();

// Map controllers to endpoints (enables attribute routing)
app.MapControllers();

app.Run();
