using Microsoft.EntityFrameworkCore;

namespace MyWebApi.Entities;

public class TestDbContext : DbContext
{
    public TestDbContext(DbContextOptions<TestDbContext> options)
        : base(options)
    {
    }

    // Define your DbSets (tables) here
    public DbSet<Product> Products { get; set; }
}
