import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";
import { Hono } from "jsr:@hono/hono";
import { cors } from "jsr:@hono/hono/cors";
import { SMTPClient } from "https://deno.land/x/denomailer/mod.ts";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

// Configure SMTP client
const smtp = new SMTPClient({
  connection: {
    hostname: "smtp.gmail.com",
    port: 465,
    tls: true,
    auth: {
      username: "aurumneuro2025@gmail.com",
      password: "owep mxjo mjqm oape",
    },
  },
});

const functionName = "notifications";
const app = new Hono().basePath(`/${functionName}`);
app.use("*", cors({
  origin: '*',
  allowMethods: ['POST', 'GET', 'OPTIONS'],
  allowHeaders: ['*'],
  exposeHeaders: ['Content-Length'],
  maxAge: 600,
  credentials: true,
}));

// Function to send email
async function sendEmail(to: string, subject: string, htmlBody: string) {
  console.log(`Sending email to ${to}: ${subject}`);
  
  try {
    await smtp.send({
      from: "sufiyan@hancod.com",
      to: to,
      subject: subject,
      content: htmlBody,
    });
    
    console.log(`Email sent successfully to ${to}`);
    return true;
  } catch (error) {
    console.error(`Failed to send email to ${to}:`, error);
    return false;
  }
}

// Endpoint to handle session notifications from database function
app.post("/session-reminder", async (c) => {
  try {
    const body = await c.req.json();
    const { email, subject, body: emailBody } = body;
    
    if (!email || !subject || !emailBody) {
      return c.json({ 
        success: false, 
        error: "Missing required fields: email, subject, or body" 
      }, 400);
    }
    
    const result = await sendEmail(email, subject, emailBody);
    
    return c.json({ 
      success: result, 
      message: result ? "Notification email sent successfully" : "Failed to send notification email" 
    });
  } catch (error) {
    console.error("Error sending session notification:", error);
    return c.json({ success: false, error: error.message }, 500);
  }
});

// Endpoint to manually trigger notifications
app.post("/", async (c) => {
  try {
    const { data: sessions, error } = await supabase
      .from("sessions")
      .select("id, start_time, notifications(user_id, users(email))")
      .gte("start_time", new Date().toISOString()) // Upcoming sessions
      .lt("start_time", new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()); // Within next 24 hours

    if (error) {
      console.error("Error fetching sessions:", error);
      return c.json({ success: false, error: error.message }, 500);
    }

    const emailPromises = [];
    for (const session of sessions) {
      for (const notification of session.notifications) {
        const email = notification.users.email;
        const sessionTime = new Date(session.start_time).toLocaleString();
        
        emailPromises.push(
          sendEmail(
            email, 
            `Reminder: Your Session is Starting Soon! 🎯`,
            `
            <!DOCTYPE html>
            <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; max-width: 600px; margin: 0 auto; padding: 20px;">
              <div style="background-color: #f8f9fa; border-radius: 10px; padding: 20px; text-align: center;">
                <!-- You can add a logo image here -->
                <img src="https://lnfjuoterxqhjpreuzgi.supabase.co/storage/v1/object/sign/assets/logo.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhc3NldHMvbG9nby5wbmciLCJpYXQiOjE3NDE2ODc0OTksImV4cCI6MTc3MzIyMzQ5OX0.U28TxqGdvQ6Arl9UZHdldTdVQTWqFQFXRK0gXeOv95s" alt="Logo" style="max-width: 150px; margin-bottom: 20px;">
                
                <h1 style="color: #2c3e50; margin-bottom: 20px;">Session Reminder</h1>
                
                <div style="background-color: white; border-radius: 8px; padding: 20px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                  <h2 style="color: #3498db; margin-bottom: 15px;">Your Session is About to Start!</h2>
                  <p style="font-size: 16px; color: #34495e;">
                    Dear Valued User,
                  </p>
                  <p style="font-size: 16px; color: #34495e;">
                    This is a friendly reminder that your session is scheduled for:
                  </p>
                  <div style="background-color: #e8f4f8; padding: 15px; border-radius: 5px; margin: 15px 0;">
                    <strong style="font-size: 18px; color: #2980b9;">${sessionTime}</strong>
                  </div>
                </div>
                
                <p style="color: #7f8c8d; font-size: 14px;">
                  Thank you for choosing our service!
                </p>
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; font-size: 12px; color: #95a5a6;">
                  © ${new Date().getFullYear()} Your Company Name. All rights reserved.
                </div>
              </div>
            </body>
            </html>
            `
          )
        );
      }
    }

    await Promise.all(emailPromises);
    return c.json({ 
      success: true, 
      message: `Sent ${emailPromises.length} notifications` 
    });
  } catch (err) {
    console.error("Error in notification function:", err);
    return c.json({ success: false, error: err.message }, 500);
  } finally {
    // Close SMTP connection
    await smtp.close();
  }
});

// Test endpoint to verify email functionality
app.get("/test-email", async (c) => {
  try {
    const email = c.req.query("email") || "test@example.com";
    
    const result = await sendEmail(
      email,
      "Test Email from Notifications Service",
      `
      Hello,

      This is a test email from the notifications service.
      If you're receiving this, the email functionality is working correctly.

      Time sent: ${new Date().toLocaleString()}
      `
    );
    
    return c.json({ 
      success: result, 
      message: result ? "Test email sent successfully" : "Failed to send test email" 
    });
  } catch (error) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

// Health check endpoint
app.get("/ping", (c) => {
  return c.json({
    status: "success",
    message: "pong",
    timestamp: new Date().toISOString()
  });
});

Deno.serve(app.fetch);
