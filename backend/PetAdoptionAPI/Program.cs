using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;

var builder = WebApplication.CreateBuilder(args);

// Register ApplicationDbContext for PostgreSQL connection
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

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
