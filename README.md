# etl-to-viz-project
## Giới thiệu

Đây là một dự án xây dựng hệ thống ETL để phục vụ báo cáo tài chính.

---

## Thành phần:
- **Cơ sở dữ liệu nguồn (MySQL)**  
  Là nơi lưu trữ dữ liệu kế toán gốc phát sinh hằng ngày: giao dịch, bút toán, tài khoản, khách hàng, nhà cung cấp,... Đây là dữ liệu thô, phục vụ cho hoạt động nghiệp vụ.

- **MinIO (lưu trữ trung gian)**  
  Là nơi lưu tạm dữ liệu đã trích xuất từ MySQL, dưới dạng file (CSV, Parquet,...). Việc sử dụng MinIO giúp:
  - Giảm tải trực tiếp lên MySQL khi xử lý nhiều dữ liệu.
  - Lưu lại bản sao dữ liệu mỗi lần ETL để kiểm tra hoặc khôi phục nếu cần.
  - Tách riêng giai đoạn trích xuất và xử lý, giúp pipeline linh hoạt hơn.

- **Kho dữ liệu (PostgreSQL)**  
  Là nơi lưu trữ dữ liệu đã xử lý và tổ chức lại theo cấu trúc phân tích (star schema). Dữ liệu tại đây được chuẩn hóa để phục vụ cho việc tạo báo cáo, dashboard trên Power BI.


## Data Pipeline
![Data Pipeline](pipeline.png)
