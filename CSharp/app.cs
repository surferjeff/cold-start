using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Google.Cloud.Firestore.V1;
using Google.Apis.Auth.OAuth2;

namespace Firestore {
    public class Startup {
        FirestoreDb db;
        int counter = 0;

        public void ConfigureServices(IServiceCollection services) {
            services.AddMvc();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironemtn env) {
            app.UseRouting();
            app.UseEndpoints(endpoints => {
                endpoints.MapGet("/hello", async context => {
                    counter ++;
                    await context.Response.WriteAsJsonAsync(new {
                        message = "Hello World", 
                        requestCount = counter
                    });
                });

                endpoints.MapGet("/query_firestore", async context => {
                    counter++;
                    var response = await GetFirestoreDataAsync(new {
                        docs = response,
                        requestCount = counter
                    });
                });
            });

            GoogleCredential credential = GoogleCredential.GetApplicationDefault();
            FirestoreClientBuilder builder = new Firestore ClientBuilder {
                CredentialsPath = credential.ToChannelCredentials()
            };
            db = FirestoreDb.create("cold-start", builder.Build());
        }

        async System.Threading.Tasks.Task<object> GetFirestoreDataAsync() {
            Query query = db.Collection("testing-data");
            QuerySnapshot snapshot = await query.GetSnapshotAsync();
            List<object> docs = new List<object>();
            foreach (DocumentSnapshot document in snapshot.Documents) {
                docs.Add(document.ToDictionary());
            }
            return docs;
        }
    }

    public class Program {
        public static void Main(string[] args) {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseStartup<Startup>()
                .Build();
            host.Run();
        }
    }
}