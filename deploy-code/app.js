const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Simple Web App - IaC Project</title>
      <style>
        body { 
          font-family: Arial, sans-serif; 
          background-color: #f5f5f5; 
          color: #333; 
          margin: 40px; 
        }
        h1 { 
          color: #2c3e50; 
        }
        p { 
          font-size: 18px; 
          line-height: 1.6; 
        }
        .footer {
          margin-top: 50px;
          font-size: 14px;
          color: #888;
        }
        code {
          background-color: #eee;
          padding: 2px 6px;
          border-radius: 4px;
          font-family: monospace;
        }
      </style>
    </head>
    <body>
      <h1>🚀 Simple Web App</h1>
      <p>This web application demonstrates a full <b>Infrastructure as Code (IaC)</b> workflow:</p>
      <ul>
        <li><b>Terraform</b>: Provisions the infrastructure including VPC, public and private subnets, and EC2 instances.</li>
        <li><b>Ansible</b>: Configures the servers, installs Node.js, npm, Nginx, and deploys this web application.</li>
        <li><b>Shell Script</b>: One single command <code>deploy.sh</code> automates the entire workflow—provisioning + configuration + deployment.</li>
      </ul>
      <p>The Node.js app runs on a private EC2 instance, and traffic is served via Nginx on a public EC2 instance acting as a reverse proxy.</p>
      
      <div class="footer">prajwal | 2025</div>
    </body>
    </html>
  `);
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App running at http://localhost:${port}`);
});
