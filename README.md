# s3_crossregion
Storage Layer : 
(1) Source bucket in us-east-1 
(2) Destination bucket in us-west-2 
Both bucket enabled with Versioning,KMS encryption. 
Versioning → Protects from accidental deletion
KMS → Protects data at rest
Bucket policy → Blocks unencrypted uploads 
 
<img width="940" height="243" alt="image" src="https://github.com/user-attachments/assets/9ecf95ac-9d7f-443e-ba07-96f4327ca581" />
<img width="940" height="214" alt="image" src="https://github.com/user-attachments/assets/08203e2a-d7ab-401f-a9f3-acff620851cb" />
<img width="940" height="193" alt="image" src="https://github.com/user-attachments/assets/237296dc-9bb3-40f8-91cc-cce41b0fca56" />
<img width="940" height="210" alt="image" src="https://github.com/user-attachments/assets/6c5e957b-46c1-4f13-899f-b6ad065f9975" />
<img width="940" height="120" alt="image" src="https://github.com/user-attachments/assets/7ccce613-95d7-458a-942e-72f1a56b3f26" />
<img width="940" height="178" alt="image" src="https://github.com/user-attachments/assets/10f82561-e144-49cb-aa06-ce02fdbb3a87" />
<img width="940" height="200" alt="image" src="https://github.com/user-attachments/assets/55991a70-ab84-446c-8650-1a25f814691d" />
<img width="940" height="145" alt="image" src="https://github.com/user-attachments/assets/159bbfc6-cca6-43d7-aa8d-99d3c441182f" />
<img width="940" height="283" alt="image" src="https://github.com/user-attachments/assets/8d71b898-7d77-473d-bbe9-873a56ee08fc" />
<img width="940" height="236" alt="image" src="https://github.com/user-attachments/assets/309b8890-d088-4035-8402-41f47a82841d" />
<img width="940" height="245" alt="image" src="https://github.com/user-attachments/assets/075746d5-1fbc-4a3e-8c33-399dc7b8479d" />
# Temporary Deny to test replication failure alarm { 
Sid = "TemporaryDenyReplication"
Effect = "Deny" 
Action = "s3:ReplicateObject" 
Resource = "${aws_s3_bucket.sclr_destination.arn}/*" }
<img width="940" height="201" alt="image" src="https://github.com/user-attachments/assets/e00fd8eb-e9bd-4cd1-b780-705f44d01d93" />

