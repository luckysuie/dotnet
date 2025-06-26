var builder = WebApplication.CreateBuilder(args);

// 🔧 Enable external access on port 5000
builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(5000);  // HTTP
    // Optional: serverOptions.ListenAnyIP(5001, listenOptions => listenOptions.UseHttps()); // HTTPS
});

// Add services to the container.
builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
  
